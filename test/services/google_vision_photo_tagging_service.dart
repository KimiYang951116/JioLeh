import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:jio_leh/services/google_vision_photo_tagging_service.dart';

void main() {
  group('GoogleVisionPhotoTaggingService.tagPhoto', () {
    test(
      'returns labels at or above the confidence threshold, lowercased',
      () async {
        final service = GoogleVisionPhotoTaggingService(
          httpClient: MockClient((req) async {
            return http.Response(
              jsonEncode({
                'responses': [
                  {
                    'labelAnnotations': [
                      {'description': 'Food', 'score': 0.95},
                      {'description': 'Outdoor', 'score': 0.72},
                      {'description': 'Blurry', 'score': 0.4},
                    ],
                  },
                ],
              }),
              200,
            );
          }),
        );

        final tags = await service.tagPhoto(Uint8List.fromList([1, 2, 3]));

        expect(tags, ['food', 'outdoor']);
      },
    );

    test('sends the expected request shape', () async {
      late http.Request captured;
      final service = GoogleVisionPhotoTaggingService(
        httpClient: MockClient((req) async {
          captured = req;
          return http.Response(jsonEncode({'responses': []}), 200);
        }),
        maxResults: 5,
      );

      final bytes = Uint8List.fromList([1, 2, 3]);
      await service.tagPhoto(bytes);

      expect(captured.method, 'POST');
      expect(captured.url.host, 'vision.googleapis.com');
      expect(captured.url.path, '/v1/images:annotate');

      final body = jsonDecode(captured.body) as Map<String, dynamic>;
      final request =
          (body['requests'] as List).single as Map<String, dynamic>;
      expect(request['image']['content'], base64Encode(bytes));
      expect(request['features'], [
        {'type': 'LABEL_DETECTION', 'maxResults': 5},
      ]);
    });

    test('returns an empty list on a non-200 response', () async {
      final service = GoogleVisionPhotoTaggingService(
        httpClient: MockClient((req) async {
          return http.Response('rate limited', 429);
        }),
      );

      final tags = await service.tagPhoto(Uint8List.fromList([1, 2, 3]));

      expect(tags, isEmpty);
    });

    test('returns an empty list when the response body is malformed', () async {
      final service = GoogleVisionPhotoTaggingService(
        httpClient: MockClient((req) async {
          return http.Response('not json', 200);
        }),
      );

      final tags = await service.tagPhoto(Uint8List.fromList([1, 2, 3]));

      expect(tags, isEmpty);
    });

    test('returns an empty list when there are no responses', () async {
      final service = GoogleVisionPhotoTaggingService(
        httpClient: MockClient((req) async {
          return http.Response(jsonEncode({'responses': []}), 200);
        }),
      );

      final tags = await service.tagPhoto(Uint8List.fromList([1, 2, 3]));

      expect(tags, isEmpty);
    });

    test('returns an empty list when the http client throws', () async {
      final service = GoogleVisionPhotoTaggingService(
        httpClient: MockClient((req) async {
          throw Exception('network down');
        }),
      );

      final tags = await service.tagPhoto(Uint8List.fromList([1, 2, 3]));

      expect(tags, isEmpty);
    });
  });
}
