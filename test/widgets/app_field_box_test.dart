import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jio_leh/widgets/app_field_box.dart';

void main() {
  // Center lets the box take its natural size instead of being stretched.
  Widget wrap(Widget child) =>
      MaterialApp(home: Scaffold(body: Center(child: child)));

  group('AppFieldBox', () {
    testWidgets('renders its child', (tester) async {
      await tester.pumpWidget(wrap(
        const AppFieldBox(height: 56, child: Text('inside')),
      ));

      expect(find.text('inside'), findsOneWidget);
    });

    testWidgets('applies its height', (tester) async {
      await tester.pumpWidget(wrap(
        const AppFieldBox(height: 56, child: SizedBox()),
      ));

      // The rendered box should be exactly the height we asked for.
      expect(tester.getSize(find.byType(AppFieldBox)).height, 56);
    });
  });
}
