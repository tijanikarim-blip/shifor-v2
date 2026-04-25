import 'package:flutter_test/flutter_test.dart';
import 'package:shifor/main.dart';

void main() {
  testWidgets('App loads splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ShiforApp());
    await tester.pump();
    expect(find.text('Shifor'), findsOneWidget);
  });
}