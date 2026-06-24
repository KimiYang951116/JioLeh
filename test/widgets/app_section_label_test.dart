import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jio_leh/widgets/app_section_label.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('AppSectionLabel', () {
    testWidgets('renders its text', (tester) async {
      await tester.pumpWidget(wrap(
        const AppSectionLabel(text: 'YOUR NAME'),
      ));

      expect(find.text('YOUR NAME'), findsOneWidget);
    });
  });
}
