import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

/// Service class responsible for handling user authentication using Supabase.
///
/// This service provides methods for signing in with Google, signing out,
/// checking the current authentication state, and retrieving user information.
class AuthService {
  /// Creates an [AuthService] instance.
  ///
  /// [client] is the real Supabase dependency used by the app.
  ///
  /// The function parameters are smaller test hooks. They let tests control
  /// auth state and behavior without signing in to Supabase for real.
  AuthService({
    SupabaseClient? client,
    Session? Function()? currentSession,
    User? Function()? currentUser,
    Future<UserResponse> Function()? getUser,
    Future<void> Function()? signOut,
  }) : _client = client,
       _currentSession = currentSession,
       _currentUser = currentUser,
       _getUser = getUser,
       _signOut = signOut;

  final SupabaseClient? _client;
  final Session? Function()? _currentSession;
  final User? Function()? _currentUser;
  final Future<UserResponse> Function()? _getUser;
  final Future<void> Function()? _signOut;

  /// Returns the underlying Supabase client.
  SupabaseClient get _supabase => _client ?? Supabase.instance.client;

  User? getCurrentUser() {
    // Tests can inject currentUser to avoid depending on Supabase global state.
    // Production falls back to the real Supabase auth user.
    if (_currentUser != null) {
      return _currentUser();
    }

    return _supabase.auth.currentUser;
  }

  Session? _getCurrentSession() {
    // Tests can inject currentSession to control signed-in state.
    // Production falls back to the real Supabase auth session.
    if (_currentSession != null) {
      return _currentSession();
    }

    return _supabase.auth.currentSession;
  }

  bool isSignedIn() {
    return _getCurrentSession() != null;
  }

  /// Checks if the current session is valid by attempting to fetch the user profile from Supabase.
  ///
  /// Returns `true` if the session is valid and the user is retrieved, `false` otherwise.
  Future<bool> hasValidSession() async {
    if (!isSignedIn()) {
      return false;
    }

    try {
      // Tests can inject getUser to control session validation results.
      // Production falls back to the real Supabase auth getUser call.
      final response = await (_getUser != null
          ? _getUser()
          : _supabase.auth.getUser());
      return response.user != null;
    } on AuthException {
      return false;
    }
  }

  /// Returns the email address of the currently signed-in user.
  ///
  /// Returns null if no user is signed in or if the user has no email.
  String? getCurrentUserEmail() {
    return getCurrentUser()?.email;
  }

  /// Returns the unique ID of the currently signed-in user.
  ///
  /// Throws a [NotSignedInException] if no user is signed in.
  String getCurrentUserId() {
    final userId = getCurrentUser()?.id;

    if (userId == null) {
      throw const NotSignedInException();
    }

    return userId;
  }

  /// Returns a stream of [AuthState] that notifies listeners of changes to the user's authentication status.
  Stream<AuthState> authStateChanges() {
    // The onAuthStateChange stream emits an event
    // whenever the authentication state changes (e.g., user signs in, signs out, or the session expires).

    // Current use: determine whether to show the AuthPage or the MapPage in app.dart
    return _supabase.auth.onAuthStateChange;
  }

  /// Initiates the Google sign-in flow using Supabase's authentication API.
  Future<void> signInWithGoogle() async {
    // Initiates the Google sign-in flow using Supabase's authentication API.
    // On web, it will open a popup; on mobile, it will launch the system browser
    // (Safari on iOS / the default browser on Android), which redirects back to the
    // app via the com.gijios.jioleh:// deep link once authentication completes.
    await _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: kIsWeb ? null : 'com.gijios.jioleh://login-callback/',
      authScreenLaunchMode: kIsWeb
          ? LaunchMode.platformDefault
          : LaunchMode.externalApplication,
    );
  }

  /// Signs out the current user from the application.
  Future<void> signOut() async {
    if (_signOut != null) {
      await _signOut();
      return;
    }

    await _supabase.auth.signOut();
  }
}

/// Base class for authentication-related exceptions raised by this app.
class AuthServiceException implements Exception {
  final String message;

  const AuthServiceException(this.message);

  @override
  String toString() => message;
}

/// Exception thrown when an operation requires a signed-in user.
class NotSignedInException extends AuthServiceException {
  const NotSignedInException() : super('User must be signed in.');
}
