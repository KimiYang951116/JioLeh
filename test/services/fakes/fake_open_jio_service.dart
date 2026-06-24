import "package:jio_leh/models/open_jio_event.dart";
import "package:jio_leh/models/user_friend.dart";
import "package:jio_leh/services/open_jio_service.dart";

class FakeOpenJioService extends OpenJioService {
  FakeOpenJioService({
    this.sentEvents = const [],
    this.receivedEvents = const [],
    this.savedEventId = "fake-event-id",
  });

  // Defaults live in the constructor, so each test sets only what it cares about.
  List<OpenJioEvent> sentEvents;
  List<OpenJioEvent> receivedEvents;
  String savedEventId;

  int saveEventCalls = 0;
  int respondToInviteCalls = 0;
  InviteStatus? lastResponse;
  void Function()? lastOnNew;

  @override
  Future<String> saveEvent(OpenJioEvent event, String senderId) async {
    saveEventCalls++;
    return savedEventId;
  }

  @override
  Future<List<OpenJioEvent>> getSentEvents(
    String userId,
    List<UserFriend> allFriends,
  ) async => sentEvents;

  @override
  Future<List<OpenJioEvent>> getReceivedEvents(String userId) async =>
      receivedEvents;

  @override
  Future<void> respondToInvite(
    String eventId,
    String userId,
    InviteStatus status,
  ) async {
    respondToInviteCalls++;
    lastResponse = status;
  }

  @override
  void Function() subscribeToInvites(String userId, void Function() onNew) {
    lastOnNew = onNew;
    return () {};
  }
}
