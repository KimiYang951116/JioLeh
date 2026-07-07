import 'package:flutter/foundation.dart';

import 'package:jio_leh/models/place.dart';
import 'package:jio_leh/models/user_pin.dart';
import 'package:jio_leh/models/user_profile.dart';
import 'package:jio_leh/services/account_service.dart';
import 'package:jio_leh/services/auth_service.dart';
import 'package:jio_leh/services/pin_service.dart';

/// One friend's pin on a shared [Place], combined with their resolved
/// profile and display-ready photo URLs, for [SharedPlaceDetailsPage].
class FriendPinEntry {
  const FriendPinEntry({
    required this.pin,
    required this.profile,
    required this.photoUrls,
    required this.isCurrentUser,
  });

  final UserPin pin;
  final UserProfile? profile;
  final List<String> photoUrls;
  final bool isCurrentUser;
}

/// Presentation state and logic for [SharedPlaceDetailsPage].
///
/// Resolves every friend's [UserPin] on [place] into a [FriendPinEntry] by
/// fetching their profile and signed photo URLs. Call [load] once after
/// construction. Mirrors the pattern in [InvitationsPageModel].
class SharedPlaceDetailsPageModel extends ChangeNotifier {
  SharedPlaceDetailsPageModel({
    required this.place,
    required this.account,
    required this.pins,
    required this.auth,
  });

  final Place place;
  final AccountService account;
  final PinService pins;
  final AuthService auth;

  List<FriendPinEntry> _entries = const [];
  bool _isLoading = true;
  String? _error;
  bool _disposed = false;

  List<FriendPinEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final currentUserId = auth.getCurrentUser()?.id;

      final entries = await Future.wait(
        place.pins.map((pin) async {
          final profile = await account.getProfileById(pin.userId);
          final photoUrls = await pins.createPhotoUrls(pin.photoPaths);
          return FriendPinEntry(
            pin: pin,
            profile: profile,
            photoUrls: photoUrls,
            isCurrentUser: pin.userId == currentUserId,
          );
        }),
      );

      if (_disposed) return;
      _entries = entries;
      _isLoading = false;
    } catch (e, st) {
      if (_disposed) return;
      debugPrint('SharedPlaceDetailsPageModel.load: $e\n$st');
      _isLoading = false;
      _error = e.toString();
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
