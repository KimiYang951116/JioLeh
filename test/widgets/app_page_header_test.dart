import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jio_leh/widgets/app_page_header.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('AppPageHeader', () {
    testWidgets('renders its title', (tester) async {
      await tester.pumpWidget(wrap(
        const AppPageHeader(title: 'Friends'),
      ));

      expect(find.text('Friends'), findsOneWidget);
    });

    testWidgets('shows the close button by default', (tester) async {
      await tester.pumpWidget(wrap(
        const AppPageHeader(title: 'Friends'),
      ));

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('hides the close button when closeBtn is false', (tester) async {
      await tester.pumpWidget(wrap(
        const AppPageHeader(title: 'Friends', closeBtn: false),
      ));

      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('tapping close pops the current route', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const Scaffold(body: AppPageHeader(title: 'Detail')),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ));

      // Navigate to the page that shows the header.
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Detail'), findsOneWidget);

      // Tapping close should pop us back off that page.
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.text('Detail'), findsNothing);
    });
  });
}
