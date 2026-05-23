import 'dart:convert';

import 'package:geolocator/geolocator.dart' as geo;
import 'package:http/http.dart' as http;
import 'package:jio_leh/config/map_env.dart';

class GeoCodingServices {
  GeoCodingServices({
    this.minIntervalSeconds = 20,
    this.minDistanceMeters = 50,
  });

  final int minIntervalSeconds;
  final int minDistanceMeters;

  DateTime? _lastFetchAt;
  geo.Position? _lastFetchPos;

  bool wouldFetch(geo.Position position) => !_isThrottled(position);

  Future<String?> fetchAreaName(
    geo.Position position, {
    bool force = false,
  }) async {
    if (!force && _isThrottled(position)) return null;

    final name = await _reverseGeocode(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    _lastFetchAt = DateTime.now();
    _lastFetchPos = position;
    return name;
  }

  bool _isThrottled(geo.Position position) {
    final lastTime = _lastFetchAt;
    final lastPos = _lastFetchPos;
    if (lastTime == null || lastPos == null) return false;

    final recentlyUpdated =
        DateTime.now().difference(lastTime).inSeconds < minIntervalSeconds;

    final hasNotMovedMuch = geo.Geolocator.distanceBetween(
          lastPos.latitude,
          lastPos.longitude,
          position.latitude,
          position.longitude,
        ) <
        minDistanceMeters;

    return recentlyUpdated && hasNotMovedMuch;
  }

  Future<String> _reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.https(
      'api.mapbox.com',
      '/search/geocode/v6/reverse',
      {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'language': 'en',
        'access_token': MapEnv.mapboxAccessToken,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to get location name: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final features = data['features'] as List<dynamic>?;

    if (features == null || features.isEmpty) {
      return 'Unknown location';
    }

    final firstFeature = features.first as Map<String, dynamic>;
    final properties =
        firstFeature['properties'] as Map<String, dynamic>? ?? {};
    final context = properties['context'] as Map<String, dynamic>? ?? {};

    final name = properties['name'] as String?;

    final neighborhood = context['neighborhood']?['name'] as String?;
    final locality = context['locality']?['name'] as String?;
    final district = context['district']?['name'] as String?;
    final place = context['place']?['name'] as String?;
    final region = context['region']?['name'] as String?;
    final country = context['country']?['name'] as String?;

    final area = neighborhood ?? locality ?? district ?? place ?? region ?? name;

    if (area != null && country != null && area != country) {
      return '$area, $country';
    }

    return area ?? country ?? 'Unknown location';
  }
}
