import 'package:jio_leh/services/sentiment_service.dart';

class FakeSentimentService extends SentimentService {
  FakeSentimentService({this.result});

  SentimentResult? result;

  int classifyCalls = 0;
  int warmUpCalls = 0;
  String? lastText;

  @override
  Future<SentimentResult?> classify(String text) async {
    classifyCalls++;
    lastText = text;
    return result;
  }

  @override
  Future<void> warmUp() async {
    warmUpCalls++;
  }
}
