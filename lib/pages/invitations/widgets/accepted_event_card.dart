import 'package:flutter/material.dart';

import 'package:jio_leh/models/open_jio_event.dart';
import 'package:jio_leh/pages/invitations/open_jio_form_page.dart';
import 'package:jio_leh/util/datetime_format.dart';

/// Organism — a tappable card for an invite the current user has accepted.
class AcceptedEventCard extends StatelessWidget {
  const AcceptedEventCard({super.key, required this.event, required this.onLeave,});

  final OpenJioEvent event;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => OpenJioFormPage(event: event)),
        ),
        leading: const Icon(Icons.check_circle_outline, color: Colors.green),
        title: Text('From ${event.senderName ?? 'Someone'}'),
        subtitle: Text(
            '${event.locationName} · ${formatDateTime(event.dateTime)}'),
        trailing: TextButton(
          onPressed: onLeave,
          child: const Text('Leave'),
      ),
      ),
    );
  }
}
