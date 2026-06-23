import 'package:jio_leh/models/user_friend.dart';

class OpenJioEvent {
  const OpenJioEvent({
    this.id, 
    required this.invitedFriends,
    required this.dateTime, 
    required this.caption,
    required this.locationName,
    this.senderId, 
    this.senderName,
    this.inviteStatus
  });

  final String? id;
  final List<UserFriend> invitedFriends;
  final DateTime dateTime;
  final String caption;
  final String locationName;
  final String? senderId; // The user ID of the person who sent the invite
  final String? senderName; // The display name of the person who sent the invite
  final String? inviteStatus; // "pending", "accepted", "declined"

  String get friendNames {
    return invitedFriends
        .map((friend) => friend.userProfile.displayName)
        .join(', ');
  }
}