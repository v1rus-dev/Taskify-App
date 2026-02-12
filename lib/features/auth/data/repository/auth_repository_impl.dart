import 'package:dart_either/dart_either.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/utils/auth_config.dart';
import 'package:taskify/features/auth/data/api/auth_api.dart';
import 'package:taskify/features/auth/data/models/auth_response_model.dart';
import 'package:taskify/features/auth/data/sources/auth_local_data_source.dart';
import 'package:taskify/features/auth/domain/models/auth_providers.dart';
import 'package:taskify/features/auth/domain/models/auth_session_entity.dart';
import 'package:taskify/features/auth/domain/repository/auth_repository.dart';
import 'package:taskify/core/auth/access_token_provider.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final AuthApi authApi;
  final AuthLocalDataSource authLocalDataSource;
  final AuthTokenHandler authTokenHandler;

  AuthRepositoryImpl({
    required this.authApi,
    required this.authLocalDataSource,
    required this.authTokenHandler,
  });

  bool _isGoogleSignInInitialized = false;

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_isGoogleSignInInitialized) {
      return;
    }

    if (googleClientId.isEmpty) {
      throw StateError('GOOGLE_CLIENT_ID is not set');
    }
    if (googleWebClientId.isEmpty) {
      throw StateError('GOOGLE_WEB_CLIENT_ID is not set');
    }

    try {
      await _googleSignIn.initialize(
        clientId: googleClientId,
        serverClientId: googleWebClientId,
      );
      _isGoogleSignInInitialized = true;
    } catch (e) {
      TalkerService.instance.error(
        'syncTag Google Sign In initialization failed',
        e,
      );
      rethrow;
    }
  }

  @override
  Future<Either<Failure, AuthSessionEntity?>> getSession() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final idToken = await user.getIdToken();
        final provider = user.providerData.isNotEmpty
            ? switch (user.providerData.first.providerId) {
                'google.com' => AuthProviders.google,
                'apple.com' => AuthProviders.apple,
                _ => AuthProviders.unknown,
              }
            : AuthProviders.unknown;

        return Right(
          AuthSessionEntity(
            provider: provider,
            uid: user.uid,
            idToken: idToken,
            email: user.email,
            displayName: user.displayName,
          ),
        );
      }

      final accessToken = await authTokenHandler.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        return Right(null);
      }

      final userResult = await authLocalDataSource.getUser();
      Failure? failure;
      AuthSessionEntity? localSession;
      userResult.fold(
        ifLeft: (left) => failure = left,
        ifRight: (localUser) {
          if (localUser == null) {
            return;
          }
          localSession = AuthSessionEntity(
            provider: _mapProvider(localUser.provider),
            uid: localUser.id,
            email: localUser.email,
            displayName: localUser.name,
          );
        },
      );

      if (failure != null) {
        return Left(failure!);
      }

      return Right(localSession);
    } catch (e) {
      TalkerService.instance.error('syncTag Get session failed', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  AuthProviders _mapProvider(String provider) {
    return switch (provider) {
      'google' || 'google.com' => AuthProviders.google,
      'apple' || 'apple.com' => AuthProviders.apple,
      'testFirst' => AuthProviders.testFirst,
      'testSecond' => AuthProviders.testSecond,
      _ => AuthProviders.unknown,
    };
  }

  @override
  Future<Either<Failure, AuthSessionEntity>> signIn({
    required AuthProviders provider,
  }) async {
    try {
      if (provider == AuthProviders.unknown) {
        return Left(const ValidationFailure('Unsupported auth provider'));
      }

      if (provider == AuthProviders.testFirst ||
          provider == AuthProviders.testSecond) {
        final authResult = provider == AuthProviders.testFirst
            ? await authApi.authenticateTestFirst<AuthResponseModel>(
                parser: (data) =>
                    AuthResponseModel.fromJson(data as Map<String, dynamic>),
              )
            : await authApi.authenticateTestSecond<AuthResponseModel>(
                parser: (data) =>
                    AuthResponseModel.fromJson(data as Map<String, dynamic>),
              );

        Failure? failure;
        AuthResponseModel? response;
        authResult.fold(
          ifLeft: (left) => failure = left,
          ifRight: (right) => response = right,
        );
        if (failure != null) {
          return Left(failure!);
        }

        final saveResult = await _saveAuthResponse(response!);
        Failure? saveFailure;
        saveResult.fold(ifLeft: (left) => saveFailure = left, ifRight: (_) {});
        if (saveFailure != null) {
          return Left(saveFailure!);
        }

        return Right(
          AuthSessionEntity(
            provider: AuthProviders.testFirst,
            uid: response!.user.id,
            email: response!.user.email,
            displayName: response!.user.name,
          ),
        );
      }

      final AuthSessionEntity session = switch (provider) {
        AuthProviders.google => await _signInWithGoogle(),
        AuthProviders.apple => await _signInWithApple(),
        AuthProviders.testFirst => throw StateError('Unreachable'),
        AuthProviders.testSecond => throw StateError('Unreachable'),
        AuthProviders.unknown => throw StateError('Unreachable'),
      };

      final idToken = session.idToken;
      if (idToken == null || idToken.isEmpty) {
        return Left(const ServerFailure('Missing id token'));
      }

      final authResult = await authApi.authenticate<AuthResponseModel>(
        provider: provider.name,
        idToken: idToken,
        parser: (data) =>
            AuthResponseModel.fromJson(data as Map<String, dynamic>),
      );

      Failure? failure;
      AuthResponseModel? response;
      authResult.fold(
        ifLeft: (left) => failure = left,
        ifRight: (right) => response = right,
      );
      if (failure != null) {
        return Left(failure!);
      }

      final saveResult = await _saveAuthResponse(response!);
      Failure? saveFailure;
      saveResult.fold(ifLeft: (left) => saveFailure = left, ifRight: (_) {});
      if (saveFailure != null) {
        return Left(saveFailure!);
      }

      return Right(session);
    } catch (e) {
      TalkerService.instance.error('syncTag Sign-in failed', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> _saveAuthResponse(
    AuthResponseModel response,
  ) async {
    final tokenResult = await authTokenHandler.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    Failure? tokenFailure;
    tokenResult.fold(ifLeft: (left) => tokenFailure = left, ifRight: (_) {});
    if (tokenFailure != null) {
      return Left(tokenFailure!);
    }

    final saveUserResult = await authLocalDataSource.saveUser(
      response.user.toEntity(),
    );
    Failure? saveUserFailure;
    saveUserResult.fold(
      ifLeft: (left) => saveUserFailure = left,
      ifRight: (_) {},
    );
    if (saveUserFailure != null) {
      return Left(saveUserFailure!);
    }

    return Right(null);
  }

  Future<AuthSessionEntity> _signInWithGoogle() async {
    await _ensureGoogleSignInInitialized();

    final GoogleSignInAccount account = await _googleSignIn.authenticate(
      scopeHint: ['email'],
    );
    final GoogleSignInAuthentication googleAuth = account.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;
    if (user == null) {
      throw StateError('Google sign-in failed');
    }

    final idToken = await user.getIdToken();
    TalkerService.instance.info('syncTag Google sign-in successful');

    return AuthSessionEntity(
      provider: AuthProviders.google,
      uid: user.uid,
      idToken: idToken,
      email: user.email,
      displayName: user.displayName,
    );
  }

  Future<AuthSessionEntity> _signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final String appleDisplayName = [
      appleCredential.givenName,
      appleCredential.familyName,
    ].whereType<String>().join(' ').trim();

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    final userCredential = await _auth.signInWithCredential(oauthCredential);
    final user = userCredential.user;
    if (user == null) {
      throw StateError('Apple sign-in failed');
    }

    final idToken = await user.getIdToken();
    debugPrint('Firebase idToken: $idToken');

    return AuthSessionEntity(
      provider: AuthProviders.apple,
      uid: user.uid,
      idToken: idToken,
      authCode: appleCredential.authorizationCode,
      email: user.email ?? appleCredential.email,
      displayName: appleDisplayName.isEmpty
          ? user.displayName
          : appleDisplayName,
    );
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      await authTokenHandler.clearTokens();
      await authLocalDataSource.clearUser();
      return Right(null);
    } catch (e) {
      TalkerService.instance.error('syncTag Sign-out failed', e);
      return Left(ServerFailure(e.toString()));
    }
  }
}
