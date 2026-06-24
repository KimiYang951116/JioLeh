import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jio_leh/widgets/app_avatar.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('AppAvatar', () {
    testWidgets('shows the default placeholder icon when image is null', (tester) async {
      await tester.pumpWidget(wrap(
        const AppAvatar(radius: 20),
      ));

      expect(find.byIcon(Icons.add_a_photo), findsOneWidget);
    });

    testWidgets('shows a custom placeholder icon', (tester) async {
      await tester.pumpWidget(wrap(
        const AppAvatar(radius: 20, placeholder: Icons.person),
      ));

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('tapping fires onTap when provided', (tester) async {
      var taps = 0;
      await tester.pumpWidget(wrap(
        AppAvatar(radius: 20, onTap: () => taps++),
      ));

      await tester.tap(find.byType(AppAvatar));

      expect(taps, 1);
    });

    testWidgets('is not tappable when onTap is null', (tester) async {
      await tester.pumpWidget(wrap(
        const AppAvatar(radius: 20),
      ));

      // No GestureDetector is added inside the avatar when onTap is null.
      expect(
        find.descendant(
          of: find.byType(AppAvatar),
          matching: find.byType(GestureDetector),
        ),
        findsNothing,
      );
    });
  });
}
