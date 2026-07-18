class SentimentResult {
  final String label;
  final double score;

  const SentimentResult({required this.label, required this.score});
}

abstract class SentimentService {
  Future<SentimentResult?> classify(String text);

  Future<void> warmUp();
}
