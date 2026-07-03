import 'package:flutter_test/flutter_test.dart';

import 'package:jio_leh/models/nearby_place.dart';
import 'package:jio_leh/services/place_service.dart';

import 'fakes/fake_place_service.dart';

void main() {
  test('FakePlaceService can stand in for PlaceService', () async {
    const place = NearbyPlace(
      placeId: 'place-1',
      name: 'Kopi Place',
      latitude: 1.35,
      longitude: 103.82,
    );
    final service = FakePlaceService(places: const [place]);
    final PlaceService contract = service;

    final places = await contract.getNearbyPlaces(
      latitude: 1.35,
      longitude: 103.82,
      radiusKm: 0.5,
    );

    expect(service.getNearbyPlacesCalls, 1);
    expect(service.lastLatitude, 1.35);
    expect(service.lastLongitude, 103.82);
    expect(service.lastRadiusKm, 0.5);
    expect(places, const [place]);
  });
}
