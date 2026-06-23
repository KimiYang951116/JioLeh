import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jio_leh/widgets/app_text_field.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child,));

  group("AppTextField", () {
    testWidgets("displays correct text", (tester) async {
      final testController = TextEditingController();
      await tester.pumpWidget(wrap(
        AppTextField(controller: testController, hintText: "Name")
      ));
      await tester.enterText(find.byType(AppTextField), "Kimi");

      expect(testController.text, 'Kimi');
    });

    testWidgets('displays hintText', (tester) async {
      await tester.pumpWidget(wrap(
        AppTextField(controller: TextEditingController(), hintText: "Name")
      ));

      expect(find.text("Name"), findsOneWidget);
    });

    testWidgets('fires onSubmitted with the typed text', (tester) async {
      // The footprint: onSubmitted hands us a String, so we capture it here.
      String? submitted;
      await tester.pumpWidget(wrap(
        AppTextField(
          controller: TextEditingController(),
          hintText: "Name",
          onSubmitted: (value) => submitted = value,
        )
      ));

      await tester.enterText(find.byType(AppTextField), "Kimi");
      // Simulate pressing the keyboard's "done"/enter action.
      await tester.testTextInput.receiveAction(TextInputAction.done);

      expect(submitted, 'Kimi');
    });

  });
}