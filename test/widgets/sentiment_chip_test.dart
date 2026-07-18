import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jio_leh/models/user_pin.dart';
import 'package:jio_leh/widgets/sentiment_chip.dart';

void main() {
  Future<void> pump(WidgetTester tester, PinSentiment sentiment) {
    return tester.pumpWidget(
      MaterialApp(home: Scaffold(body: SentimentChip(sentiment: sentiment))),
    );
  }

  testWidgets('positive renders Positive', (tester) async {
    await pump(tester, PinSentiment.positive);
    expect(find.text('Positive'), findsOneWidget);
  });

  testWidgets('negative renders Negative', (tester) async {
    await pump(tester, PinSentiment.negative);
    expect(find.text('Negative'), findsOneWidget);
  });

  testWidgets('mixed renders Mixed', (tester) async {
    await pump(tester, PinSentiment.mixed);
    expect(find.text('Mixed'), findsOneWidget);
  });
}
