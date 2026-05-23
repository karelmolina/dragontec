import 'package:dragontec/app.dart';
import 'package:dragontec/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    await dotenv.load(fileName: '.env');
    await initDependencies();
  });

  testWidgets('App renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const DragontecApp());

    // Verify that the splash screen shows the app name.
    expect(find.text('Horus Logistic'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
