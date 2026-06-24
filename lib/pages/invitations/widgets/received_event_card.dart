import 'package:flutter/material.dart';

import 'package:jio_leh/models/open_jio_event.dart';
import 'package:jio_leh/util/datetime_format.dart';

/// Organism — a card for a pending invite, with Accept and Decline actions.
class ReceivedEventCard extends StatelessWidget {
  const ReceivedEventCard({
    super.key,
    required this.event,
    required this.onAccept,
    required this.onDecline,
  });

  final OpenJioEvent event;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.mail_outline, size: 20),
                const SizedBox(width: 8),
                Text(
                  'From ${event.senderName ?? 'Someone'}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
                '${event.locationName} · ${formatDateTime(event.dateTime)}'),
            if (event.caption.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(event.caption,
                  style: const TextStyle(color: Colors.grey)),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDecline,
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: onAccept,
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
