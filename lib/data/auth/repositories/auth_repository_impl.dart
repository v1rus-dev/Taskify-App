import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/utils/auth_config.dart';
import 'package:taskify/domain/auth/models/auth_providers.dart';
import 'package:taskify/domain/auth/models/auth_session.dart';
import 'package:taskify/domain/auth/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
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
  Future<AuthSession?> getSession() async {
    final user = _auth.currentUser;
    if (user == null) {
      return null;
    }

    final idToken = await user.getIdToken();
    final provider = user.providerData.isNotEmpty
        ? switch (user.providerData.first.providerId) {
            'google.com' => AuthProviders.google,
            'apple.com' => AuthProviders.apple,
            _ => AuthProviders.unknown,
          }
        : AuthProviders.unknown;

    return AuthSession(
      provider: provider,
      uid: user.uid,
      idToken: idToken,
      email: user.email,
      displayName: user.displayName,
    );
  }

  @override
  Future<AuthSession> signInWithGoogle() async {
    try {
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
    } catch (e) {
      TalkerService.instance.error('Google sign-in failed', e);
      rethrow;
    }
  }

  @override
  Future<AuthSession> signInWithApple() async {
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
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
