import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:taskify/core/services/auth_service.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/utils/auth_config.dart';
import 'package:taskify/domain/auth/models/auth_session.dart';
import 'package:taskify/domain/auth/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  @override
  Future<AuthSession?> getSession() async {
    final user = _auth.currentUser;
    if (user == null) {
      return null;
    }

    final idToken = await user.getIdToken();
    final provider = user.providerData.isNotEmpty
        ? user.providerData.first.providerId
        : 'firebase';

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
      final account = await _authService.signInWithGoogle();
      TalkerService.instance.info('Google sign-in successful');

      return AuthSession(
        provider: 'google',
        uid: account.id,
        idToken: account.authentication.idToken,
        email: account.email,
        displayName: account.displayName,
      );
    } catch (e) {
      TalkerService.instance.error('Google sign-in failed', e);
      rethrow;
    }
  }

  // @override
  // Future<AuthSession> signInWithGoogle() async {
  //   TalkerService.instance.info('Sign in with Google start');
  //   if (googleWebClientId.isEmpty) {
  //     throw StateError('GOOGLE_WEB_CLIENT_ID is not set');
  //   }

  //   TalkerService.instance.info('Google web client id: $googleWebClientId');

  //   await GoogleSignIn.instance.initialize(serverClientId: googleWebClientId);

  //   TalkerService.instance.info('Google sign in initialized');

  //   final GoogleSignInAccount googleUser = await GoogleSignIn.instance
  //       .authenticate();

  //   TalkerService.instance.info('Google user: $googleUser');

  //   final GoogleSignInAuthentication googleAuth = googleUser.authentication;

  //   final credential = GoogleAuthProvider.credential(
  //     idToken: googleAuth.idToken,
  //     accessToken: googleAuth.idToken,
  //   );

  //   TalkerService.instance.info('Google credential: $credential');

  //   final userCredential = await _auth.signInWithCredential(credential);
  //   final user = userCredential.user;
  //   if (user == null) {
  //     throw StateError('Google sign-in failed');
  //   }

  //   TalkerService.instance.info('User: $user');

  //   final idToken = await user.getIdToken();
  //   TalkerService.instance.info('Firebase idToken: $idToken');

  //   return AuthSession(
  //     provider: 'google',
  //     uid: user.uid,
  //     idToken: idToken,
  //     email: user.email,
  //     displayName: user.displayName,
  //   );
  // }

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
      provider: 'apple',
      uid: user.uid,
      idToken: idToken,
      authCode: appleCredential.authorizationCode,
      email: user.email ?? appleCredential.email,
      displayName: appleDisplayName == null || appleDisplayName.isEmpty
          ? user.displayName
          : appleDisplayName,
    );
  }

  @override
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }
}
