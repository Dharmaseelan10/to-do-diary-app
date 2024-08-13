import 'package:flutter_test/flutter_test.dart';
import 'package:diary_app/main.dart'; // Ensure this path is correct

void main() {
  testWidgets('Example widget test', (WidgetTester tester) async {
    // Build the widget and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Add your widget test logic here
    expect(find.text('Expected Text'), findsOneWidget);
  });
}
