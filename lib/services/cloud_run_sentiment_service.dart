import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:jio_leh/config/sentiment_env.dart';
import 'package:jio_leh/services/sentiment_service.dart';

class CloudRunSentimentService extends SentimentService {
  CloudRunSentimentService({
    http.Client? httpClient,
    this.timeout = const Duration(seconds: 10),
  }) : _httpClient = httpClient ?? http.Client();

  static const _baseUrl =
      'https://jioleh-sentiment-api-wrvvk4l64a-as.a.run.app';

  final http.Client _httpClient;
  final Duration timeout;

  @override
  Future<SentimentResult?> classify(String text) async {
    try {
      final response = await _httpClient
          .post(
            Uri.parse('$_baseUrl/classify'),
            headers: {
              'Content-Type': 'application/json',
              'x-api-key': SentimentEnv.apiKey,
            },
            body: jsonEncode({'text': text}),
          )
          .timeout(timeout);

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final label = data['label'] as String?;
      final score = data['score'] as num?;

      if (score == null || (label != 'POSITIVE' && label != 'NEGATIVE')) {
        return null;
      }

      return SentimentResult(label: label!, score: score.toDouble());
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> warmUp() async {
    try {
      await _httpClient.get(Uri.parse(_baseUrl)).timeout(timeout);
    } catch (_) {}
  }
}
