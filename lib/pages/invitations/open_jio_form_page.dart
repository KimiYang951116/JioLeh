import 'package:flutter/material.dart';

import 'package:jio_leh/models/open_jio_event.dart';
import 'package:jio_leh/models/user_friend.dart';
import 'package:jio_leh/services/services.dart';

class OpenJioFormPage extends StatefulWidget {
  const OpenJioFormPage({super.key});

  @override
  State<OpenJioFormPage> createState() => _OpenJioFormPageState();
}

class _OpenJioFormPageState extends State<OpenJioFormPage> {
  final _friends = Services.friends;
  final Set<String> _selectedFriendIds = {};

  late Future<List<UserFriend>> _future;

  @override
  void initState() {
    super.initState();
    _future = _friends.getUserFriends();
  }

  void _toggleFriend(UserFriend friend) {
    final friendId = friend.userProfile.id;

    setState(() {
      if (_selectedFriendIds.contains(friendId)) {
        _selectedFriendIds.remove(friendId);
      } else {
        _selectedFriendIds.add(friendId);
      }
    });
  }

  void _openJio(List<UserFriend> friends) {
    final selectedFriends = friends
        .where((friend) => _selectedFriendIds.contains(friend.userProfile.id))
        .toList();

    Navigator.pop(
      context,
      OpenJioEvent(invitedFriends: selectedFriends),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open a Jio'),
      ),
      body: FutureBuilder<List<UserFriend>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final friends = (snapshot.data ?? [])
              .where((friend) => friend.status == FriendshipStatus.accepted)
              .toList();

          return Column(
            children: [
              Expanded(
                child: friends.isEmpty
                    ? const Center(child: Text('No friends yet'))
                    : ListView.builder(
                        itemCount: friends.length,
                        itemBuilder: (context, index) {
                          final friend = friends[index];
                          final isSelected = _selectedFriendIds.contains(
                            friend.userProfile.id,
                          );

                          return ListTile(
                            onTap: () => _toggleFriend(friend),
                            title: Text(friend.userProfile.displayName),
                            subtitle: Text('@${friend.userProfile.username}'),
                            trailing: IconButton(
                              tooltip: isSelected
                                  ? 'Remove from OpenJio'
                                  : 'Add to OpenJio',
                              onPressed: () => _toggleFriend(friend),
                              icon: Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                              ),
                            ),
                          );
                        },
                      ),
              ),
              SafeArea(
                minimum: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedFriendIds.isEmpty
                        ? null
                        : () => _openJio(friends),
                    child: const Text('OpenJio'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}