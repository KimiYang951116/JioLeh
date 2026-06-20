import 'package:jio_leh/models/user_friend.dart';

class OpenJioEvent {
  const OpenJioEvent({
    required this.invitedFriends,
    required this.dateTime, 
    required this.caption,
  });

  final List<UserFriend> invitedFriends;
  final DateTime dateTime;
  final String caption;

  String get friendNames {
    return invitedFriends
        .map((friend) => friend.userProfile.displayName)
        .join(', ');
  }
}