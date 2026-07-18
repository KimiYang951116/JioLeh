import 'package:flutter/material.dart';

import 'package:jio_leh/models/user_pin.dart';
import 'package:jio_leh/theme.dart';

class SentimentChip extends StatelessWidget {
  const SentimentChip({super.key, required this.sentiment});

  final PinSentiment sentiment;

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;

    if (sentiment == PinSentiment.positive) {
      label = 'Positive';
      color = AppColors.sentimentPositive;
    } else if (sentiment == PinSentiment.negative) {
      label = 'Negative';
      color = AppColors.sentimentNegative;
    } else {
      label = 'Mixed';
      color = AppColors.sentimentMixed;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: AppTextSizes.caption,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
