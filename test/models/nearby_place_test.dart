import 'package:flutter_test/flutter_test.dart';
import 'package:jio_leh/models/nearby_place.dart';

void main() {
  group('NearbyPlace.fromMap', () {
    test('parses id, name, location and address', () {
      final map = {
        'id': 'place-1',
        'displayName': {'text': 'Kopi Place', 'languageCode': 'en'},
        'formattedAddress': '123 Example Rd, Singapore',
        'location': {'latitude': 1.3521, 'longitude': 103.8198},
      };

      final place = NearbyPlace.fromMap(map);

      expect(place.placeId, 'place-1');
      expect(place.name, 'Kopi Place');
      expect(place.latitude, 1.3521);
      expect(place.longitude, 103.8198);
      expect(place.address, '123 Example Rd, Singapore');
    });

    test('defaults missing fields safely', () {
      final place = NearbyPlace.fromMap(const {});

      expect(place.placeId, '');
      expect(place.name, 'Unnamed place');
      expect(place.latitude, 0);
      expect(place.longitude, 0);
      expect(place.address, isNull);
    });
  });
}
