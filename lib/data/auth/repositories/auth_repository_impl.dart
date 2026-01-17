import 'package:dart_either/dart_either.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/utils/auth_config.dart';
import 'package:taskify/data/api/auth_api.dart';
import 'package:taskify/domain/auth/models/auth_providers.dart';
import 'package:taskify/domain/auth/models/auth_session.dart';
import 'package:taskify/domain/auth/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final AuthApi authApi;

  AuthRepositoryImpl({required this.authApi});

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
      TalkerService.instance.error('Google Sign In initialization failed', e);
      rethrow;
    }
  }

  @override
  Future<Either<Failure, AuthSession?>> getSession() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return Right(null);
      }

      final idToken = await user.getIdToken();
      final provider = user.providerData.isNotEmpty
          ? switch (user.providerData.first.providerId) {
              'google.com' => AuthProviders.google,
              'apple.com' => AuthProviders.apple,
              _ => AuthProviders.unknown,
            }
          : AuthProviders.unknown;

      return Right(
        AuthSession(
          provider: provider,
          uid: user.uid,
          idToken: idToken,
          email: user.email,
          displayName: user.displayName,
        ),
      );
    } catch (e) {
      TalkerService.instance.error('Get session failed', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthSession>> signIn({
    required AuthProviders provider,
  }) async {
    try {
      if (provider == AuthProviders.unknown) {
        return Left(const ValidationFailure('Unsupported auth provider'));
      }

      final AuthSession session = switch (provider) {
        AuthProviders.google => await _signInWithGoogle(),
        AuthProviders.apple => await _signInWithApple(),
        AuthProviders.unknown => throw StateError('Unreachable'),
      };

      final idToken = session.idToken;
      if (idToken == null || idToken.isEmpty) {
        return Left(const ServerFailure('Missing id token'));
      }

      final authResult = await authApi.authenticate<void>(
        provider: provider.name,
        idToken: idToken,
        parser: (_) => null,
      );

      return authResult.fold(
        ifLeft: (failure) => Left(failure),
        ifRight: (_) => Right(session),
      );
    } catch (e) {
      TalkerService.instance.error('Sign-in failed', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<AuthSession> _signInWithGoogle() async {
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
    TalkerService.instance.info('Google sign-in successful');

    return AuthSession(
      provider: AuthProviders.google,
      uid: user.uid,
      idToken: idToken,
      email: user.email,
      displayName: user.displayName,
    );
  }

  Future<AuthSession> _signInWithApple() async {
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

    return AuthSession(
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
      return Right(null);
    } catch (e) {
      TalkerService.instance.error('Sign-out failed', e);
      return Left(ServerFailure(e.toString()));
    }
  }
}
