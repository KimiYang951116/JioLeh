import 'dart:async';

import 'package:flutter/material.dart';

import 'package:jio_leh/pages/auth/login_page.dart';
import 'package:jio_leh/pages/map/map_page.dart';
import 'package:jio_leh/pages/auth/onboarding_page.dart';

import 'package:jio_leh/routing/app_routing.dart';
import 'package:jio_leh/routing/auth_gate_resolver.dart';
import 'package:jio_leh/routing/deep_link_parser.dart';

import 'package:jio_leh/services/account_service.dart';
import 'package:jio_leh/services/auth_service.dart';
import 'package:jio_leh/services/service_provider.dart';

import 'package:app_links/app_links.dart';

enum _GateState { loading, signedOut, needsOnboarding, ready, error }

/// Decides which first screen the app should show based on auth state.
///
/// This widget is a small UI gate: it listens for auth changes, asks the
/// resolver for the current app state, then renders login, onboarding, map, or
/// retry UI. Services come from the nearest [ServiceProvider]; tests wrap the
/// gate in a [ServiceProvider] with fakes.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  // Services come from the ServiceProvider above this widget. They can't be
  // read in initState, so they're assigned in didChangeDependencies.
  late final AuthService _auth;
  late final AccountService _account;
  bool _didInit = false;
  late final StreamSubscription<dynamic> _authSub;
  _GateState _state = _GateState.loading;
  late final AppLinks _appLinks;
  late final StreamSubscription<Uri> _linkSub;

  // A profile link can arrive before auth/profile checks finish. Keep the id
  // here, then open it once the gate reaches the ready state.
  String? _pendingProfileId;

  void _handleLink(Uri uri) {
    // Keep URI parsing outside the widget so the link format can be tested
    // without building Flutter UI.
    final profileId = profileIdFromDeepLink(uri);

    if (profileId == null) return;

    _pendingProfileId = profileId;
    _openPendingProfile();
  }

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _linkSub = _appLinks.uriLinkStream.listen(_handleLink);
  }

  // didChangeDependencies runs just AFTER initState, and again any time an InheritedWidget we read from changes
  // We use it (not initState) because reading ServiceProvider.of(context) needs the widget to be wired into the
  // tree first, which isn't true yet in initState.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // This method can run more than once, but our setup (subscribe to auth,
    // resolve the first screen) must happen exactly once. The _didInit flag
    // makes it run-once: do the work, flip the flag, skip on later calls.
    if (_didInit) return;
    _didInit = true;

    // Now it's safe to read the services handed down by the ServiceProvider
    // above us in the tree.
    final services = ServiceProvider.of(context)!;
    _auth = services.auth;
    _account = services.account;

    // Re-resolve whenever the user signs in or out, then resolve once now
    // for the current session.
    _authSub = _auth.authStateChanges().listen((_) => _resolve());
    _resolve();
  }

  @override
  void dispose() {
    _authSub.cancel();
    _linkSub.cancel();
    super.dispose();
  }

  Future<void> _resolve() async {
    setState(() => _state = _GateState.loading);

    try {
      // AuthGate handles UI state only. The resolver owns the decision rules
      // for signed out vs onboarding vs ready.
      final result = await resolveAuthGateState(
        isSignedIn: _auth.isSignedIn,
        hasValidSession: _auth.hasValidSession,
        profileExists: _account.profileExists,
      );

      // The widget may be disposed while waiting for Supabase/profile checks.
      // In that case, do not call setState on a dead widget.
      if (!mounted) return;

      if (result == AuthGateResult.signedOut) {
        setState(() => _state = _GateState.signedOut);
      } else if (result == AuthGateResult.needsOnboarding) {
        setState(() => _state = _GateState.needsOnboarding);
      } else {
        setState(() => _state = _GateState.ready);
        _openPendingProfile();
      }
    } catch (_) {
      // Non-auth failures, such as temporary network/profile lookup errors,
      // become a retry screen instead of forcing the user to login.
      if (!mounted) return;
      setState(() => _state = _GateState.error);
    }
  }

  void _openPendingProfile() {
    final profileId = _pendingProfileId;

    if (_state != _GateState.ready || profileId == null) return;

    _pendingProfileId = null;

    // Navigation should happen after the current frame, not during a build or
    // state update. This keeps Flutter navigation timing safe.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).push(AppRoutes.profile(profileId));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_state == _GateState.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_state == _GateState.signedOut) {
      return const AuthPage();
    }

    if (_state == _GateState.needsOnboarding) {
      // onComplete re-runs the check so the gate moves to MapPage once the
      // profile row has been inserted.
      return OnboardingPage(onComplete: _resolve);
    }

    if (_state == _GateState.ready) {
      return const MapPage();
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Something went wrong.'),
            const SizedBox(height: 12),
            FilledButton(onPressed: _resolve, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
