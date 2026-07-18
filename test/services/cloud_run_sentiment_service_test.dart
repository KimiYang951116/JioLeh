import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:jio_leh/services/cloud_run_sentiment_service.dart';

void main() {
  group('CloudRunSentimentService.classify', () {
    test('parses a valid response into a SentimentResult', () async {
      final service = CloudRunSentimentService(
        httpClient: MockClient((req) async {
          return http.Response(
            jsonEncode({'label': 'POSITIVE', 'score': 0.99}),
            200,
          );
        }),
      );

      final result = await service.classify('great food');

      expect(result, isNotNull);
      expect(result!.label, 'POSITIVE');
      expect(result.score, 0.99);
    });

    test('returns null on a non-200 status', () async {
      final service = CloudRunSentimentService(
        httpClient: MockClient((req) async => http.Response('error', 500)),
      );

      expect(await service.classify('great food'), isNull);
    });

    test('returns null on a malformed body', () async {
      final service = CloudRunSentimentService(
        httpClient: MockClient((req) async => http.Response('oops', 200)),
      );

      expect(await service.classify('great food'), isNull);
    });

    test('returns null on an unknown label', () async {
      final service = CloudRunSentimentService(
        httpClient: MockClient((req) async {
          return http.Response(
            jsonEncode({'label': 'NEUTRAL', 'score': 0.9}),
            200,
          );
        }),
      );

      expect(await service.classify('great food'), isNull);
    });

    test('sends the expected request shape', () async {
      late http.Request captured;
      final service = CloudRunSentimentService(
        httpClient: MockClient((req) async {
          captured = req;
          return http.Response(
            jsonEncode({'label': 'POSITIVE', 'score': 0.9}),
            200,
          );
        }),
      );

      await service.classify('hello');

      expect(captured.method, 'POST');
      expect(captured.url.path, '/classify');
      expect(captured.headers['x-api-key'], isNotNull);
      expect(jsonDecode(captured.body), {'text': 'hello'});
    });

    test('returns null when the client throws', () async {
      final service = CloudRunSentimentService(
        httpClient: MockClient((req) async {
          throw http.ClientException('no network');
        }),
      );

      expect(await service.classify('great food'), isNull);
    });
  });

  group('CloudRunSentimentService.warmUp', () {
    test('swallows transport errors', () async {
      final service = CloudRunSentimentService(
        httpClient: MockClient((req) async {
          throw http.ClientException('no network');
        }),
      );

      await service.warmUp();
    });

    test('fires a GET at the service root', () async {
      late http.Request captured;
      final service = CloudRunSentimentService(
        httpClient: MockClient((req) async {
          captured = req;
          return http.Response('', 404);
        }),
      );

      await service.warmUp();

      expect(captured.method, 'GET');
    });
  });
}
