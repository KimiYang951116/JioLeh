import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jio_leh/pages/auth/onboarding_widgets.dart';

void main() {
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  // We use November to test cuz its the longest month name
  Widget buildForm() {
    return MaterialApp(
      home: Scaffold(
        body: ProfileForm(
          displayNameController: TextEditingController(),
          dayController: TextEditingController(),
          yearController: TextEditingController(),
          selectedMonth: 'November',
          months: months,
          onMonthChanged: (_) {},
        ),
      ),
    );
  }

  // Sets the fake screen to a given logical size for one test, then restores it.
  // devicePixelRatio = 1.0 makes logical size == the numbers we pass in.
  void setScreenSize(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  // A few representative widths: smallest iPhone, iPhone 16 Pro, a large phone.
  final devices = <String, Size>{
    'iPhone SE (320 wide)': const Size(320, 800),
    'iPhone 16 Pro (402 wide)': const Size(402, 874),
    'large phone (440 wide)': const Size(440, 900),
  };

  devices.forEach((name, size) {
    testWidgets('renders the form without overflow on $name', (tester) async {
      setScreenSize(tester, size);

      await tester.pumpWidget(buildForm());

      // An overflow during layout is recorded as an exception. None expected.
      expect(tester.takeException(), isNull);

      // The labels and the long month value should all be present.
      expect(find.text('YOUR NAME'), findsOneWidget);
      expect(find.text('BIRTHDAY · OPTIONAL'), findsOneWidget);
      expect(find.text('November'), findsOneWidget);
    });
  });
}
