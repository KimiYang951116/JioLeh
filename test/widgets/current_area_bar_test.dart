import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jio_leh/pages/map/widgets/current_area_bar.dart';

void main() {
  // CurrentAreaBar is a Positioned, so it must live inside a Stack.
  Widget wrap(Widget child) =>
      MaterialApp(home: Scaffold(body: Stack(children: [child])));

  group('CurrentAreaBar', () {
    testWidgets('renders the location name', (tester) async {
      await tester.pumpWidget(wrap(
        const CurrentAreaBar(locationName: 'Leh, Ladakh'),
      ));

      expect(find.text('Leh, Ladakh'), findsOneWidget);
    });

    testWidgets('shows a location icon', (tester) async {
      await tester.pumpWidget(wrap(
        const CurrentAreaBar(locationName: 'Leh, Ladakh'),
      ));

      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });
  });
}
