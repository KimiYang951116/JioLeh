import 'package:flutter/material.dart';
import 'package:jio_leh/services/location_service.dart';
import 'package:jio_leh/widgets/app_dialog.dart';

String _locationErrorMessage(Object? error) {
  if (error is LocationServiceOff) {
    return 'Location services are turned off. Please enable them and try again.';
  }
  if (error is LocationBlocked) {
    return 'Location permission was permanently denied. Open settings to grant access.';
  }
  if (error is LocationDenied) {
    return 'Location permission is required to use the map.';
  }
  return 'Unable to fetch your location. Please try again.';
}

Future<void> showLocationErrorDialog({
  required BuildContext context,
  required Object error,
  required LocationService locationService,
  required VoidCallback onRetry,
}) async {
  await showAppDialog<void>(
    context: context,
    icon: Icons.location_off,
    title: 'Location unavailable',
    message: _locationErrorMessage(error),
    actions: [
      const AppDialogAction(label: 'Cancel'),
      if (error is LocationServiceOff)
        AppDialogAction(
          label: 'Open location settings',
          onPressed: locationService.openLocationSettings,
        ),
      if (error is LocationBlocked)
        AppDialogAction(
          label: 'Open app settings',
          onPressed: locationService.openAppSettings,
        ),
      AppDialogAction(
        label: 'Retry',
        isPrimary: true,
        onPressed: onRetry,
      ),
    ],
  );
}
