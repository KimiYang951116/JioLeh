import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jio_leh/pages/map/widgets/map_toolbar.dart';

void main() {
  // MapToolbar is a Positioned, so it must live inside a Stack.
  Widget wrap(Widget child) =>
      MaterialApp(home: Scaffold(body: Stack(children: [child])));

  group('MapToolbar', () {
    testWidgets('tapping the recenter button fires onRecenter', (tester) async {
      var recenters = 0;
      await tester.pumpWidget(wrap(
        MapToolbar(onRecenter: () => recenters++, onAddPin: () {}),
      ));

      await tester.tap(find.byIcon(Icons.my_location));

      expect(recenters, 1);
    });

    testWidgets('tapping the add-pin button fires onAddPin', (tester) async {
      var addPins = 0;
      await tester.pumpWidget(wrap(
        MapToolbar(onRecenter: () {}, onAddPin: () => addPins++),
      ));

      await tester.tap(find.byIcon(Icons.place));

      expect(addPins, 1);
    });
  });
}
