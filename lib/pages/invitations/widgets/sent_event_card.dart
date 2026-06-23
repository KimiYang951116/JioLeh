import 'package:flutter/material.dart';

import 'package:jio_leh/models/open_jio_event.dart';
import 'package:jio_leh/pages/invitations/open_jio_form_page.dart';
import 'package:jio_leh/util/datetime_format.dart';

/// Organism — a tappable card for a jio the current user sent.
class SentEventCard extends StatelessWidget {
  const SentEventCard({super.key, required this.event});

  final OpenJioEvent event;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => OpenJioFormPage(event: event)),
        ),
        leading: const Icon(Icons.markunread_mailbox),
        title: Text('To ${event.friendNames}'),
        subtitle:
            Text('${event.locationName} · ${formatDateTime(event.dateTime)}'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
