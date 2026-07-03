import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jio_leh/app/service_provider.dart';
import 'package:jio_leh/pages/map/location_customize_page.dart';
import 'package:jio_leh/pages/map/models/pin_type.dart';

import '../../services/fakes/fake_place_service.dart';

void main() {
  Widget wrap(Widget child, {required FakePlaceService places}) {
    return MaterialApp(home: ServiceProvider(places: places, child: child));
  }

  group('LocationCustomizePage nearby-place fetch', () {
    testWidgets('fetches nearby places using the given coordinates', (
      tester,
    ) async {
      final places = FakePlaceService();

      await tester.pumpWidget(
        wrap(
          const LocationCustomizePage(
            selectedType: PinType.restaurant,
            latitude: 1.35,
            longitude: 103.82,
          ),
          places: places,
        ),
      );
      await tester.pump();

      expect(places.getNearbyPlacesCalls, 1);
      expect(places.lastLatitude, 1.35);
      expect(places.lastLongitude, 103.82);
    });

    testWidgets('does not fetch when read-only', (tester) async {
      final places = FakePlaceService();

      await tester.pumpWidget(
        wrap(
          const LocationCustomizePage(
            selectedType: PinType.restaurant,
            isReadOnly: true,
            latitude: 1.35,
            longitude: 103.82,
          ),
          places: places,
        ),
      );
      await tester.pump();

      expect(places.getNearbyPlacesCalls, 0);
    });

    testWidgets('does not fetch when coordinates are not provided', (
      tester,
    ) async {
      final places = FakePlaceService();

      await tester.pumpWidget(
        wrap(
          const LocationCustomizePage(selectedType: PinType.restaurant),
          places: places,
        ),
      );
      await tester.pump();

      expect(places.getNearbyPlacesCalls, 0);
    });
  });
}
