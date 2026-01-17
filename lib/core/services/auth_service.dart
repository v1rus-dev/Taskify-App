import 'package:google_sign_in/google_sign_in.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/utils/auth_config.dart';

class AuthService {
  final _googleSignIn = GoogleSignIn.instance;
  GoogleSignInAccount? _currentAccount;
  GoogleSignInAccount? get currentAccount => _currentAccount;
  bool _isGoogleSignInInitialized = false;

  bool get isSignedIn => _currentAccount != null;

  AuthService() {
    _initializeGoogleSignIn();
  }

  Future<void> _initializeGoogleSignIn() async {
    try {
      if (googleClientId.isEmpty) {
        throw StateError('GOOGLE_CLIENT_ID is not set');
      }
      if (googleWebClientId.isEmpty) {
        throw StateError('GOOGLE_WEB_CLIENT_ID is not set');
      }
      TalkerService.instance.info('Google client id: $googleClientId');
      TalkerService.instance.info('Google web client id: $googleWebClientId');
      await _googleSignIn.initialize(clientId: googleClientId, serverClientId: googleWebClientId);
      _isGoogleSignInInitialized = true;
      TalkerService.instance.info('Google Sign In initialized');
    } catch (e) {
      TalkerService.instance.error('Error initializing Google Sign In', e);
    }
  }

  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isGoogleSignInInitialized) {
      await _initializeGoogleSignIn();
    }
  }

  Future<GoogleSignInAccount> signInWithGoogle() async {
    await _ensureGoogleSignInInitialized();

    try {
      // authenticate() throws exceptions instead of returning null
      final GoogleSignInAccount account = await _googleSignIn.authenticate(
        scopeHint: ['email'], // Specify required scopes
      );
      return account;
    } on GoogleSignInException catch (e) {
      TalkerService.instance.error(
        'Google Sign In error: code: ${e.code.name} description:${e.description} details:${e.details}',
      );
      rethrow;
    } catch (error) {
      TalkerService.instance.error('Unexpected Google Sign-In error: $error');
      rethrow;
    }
  }

  Future<GoogleSignInAccount?> attemptSilentSignIn() async {
    await _ensureGoogleSignInInitialized();

    try {
      // attemptLightweightAuthentication can return Future or immediate result
      final result = _googleSignIn.attemptLightweightAuthentication();

      // Handle both sync and async returns
      if (result is Future<GoogleSignInAccount?>) {
        return await result;
      } else {
        return result as GoogleSignInAccount?;
      }
    } catch (error) {
      TalkerService.instance.error('Silent sign-in failed: $error');
      return null;
    }
  }

  GoogleSignInAuthentication getAuthTokens(GoogleSignInAccount account) {
    // authentication is now synchronous
    return account.authentication;
  }

  Future<String?> getAccessTokenForScopes(List<String> scopes) async {
    await _ensureGoogleSignInInitialized();

    try {
      final authClient = _googleSignIn.authorizationClient;

      // Try to get existing authorization
      var authorization = await authClient.authorizationForScopes(scopes);

      authorization ??= await authClient.authorizeScopes(scopes);

      return authorization.accessToken;
    } catch (error) {
      TalkerService.instance.error(
        'Failed to get access token for scopes: $error',
      );
      return null;
    }
  }

  Future<void> signIn() async {
    try {
      _currentAccount = await signInWithGoogle();
      TalkerService.instance.info(
        'Signed in with Google: ${_currentAccount?.displayName}',
      );
    } catch (e) {
      TalkerService.instance.error('Error signing in with Google: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _currentAccount = null;
      TalkerService.instance.info('Signed out');
    } catch (e) {
      TalkerService.instance.error('Error signing out: $e');
      rethrow;
    }
  }
}
