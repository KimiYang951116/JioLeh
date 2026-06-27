import 'package:flutter/material.dart';

import 'package:jio_leh/theme.dart';

class AppDialogAction<T> {
  const AppDialogAction({
    required this.label,
    this.value,
    this.onPressed,
    this.isPrimary = false,
    this.isDestructive = false,
  });

  final String label;
  final T? value;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isDestructive;
}

Future<T?> showAppDialog<T>({
  required BuildContext context,
  required String title,
  String? message,
  IconData? icon,
  List<AppDialogAction<T>> actions = const [],
}) {
  return showDialog<T>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: icon == null ? null : Icon(icon, size: 40, color: Colors.grey),
      title: Text(title),
      content: message == null ? null : Text(message),
      actions: [
        for (final action in actions)
          if (action.isPrimary)
            FilledButton(
              style: action.isDestructive
                  ? FilledButton.styleFrom(backgroundColor: AppColors.danger)
                  : null,
              onPressed: () {
                Navigator.pop(dialogContext, action.value);
                action.onPressed?.call();
              },
              child: Text(action.label),
            )
          else
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, action.value);
                action.onPressed?.call();
              },
              child: Text(action.label),
            ),
      ],
    ),
  );
}

Future<bool> showAppConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  bool isDestructive = false,
}) async {
  final confirmed = await showAppDialog<bool>(
    context: context,
    title: title,
    message: message,
    actions: [
      AppDialogAction(label: cancelLabel, value: false),
      AppDialogAction(
        label: confirmLabel,
        value: true,
        isPrimary: true,
        isDestructive: isDestructive,
      ),
    ],
  );

  return confirmed ?? false;
}
