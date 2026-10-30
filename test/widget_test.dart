import 'package:flutter_test/flutter_test.dart';
import 'package:pastel_store/main.dart';

void main() {
  testWidgets('Pastel Store app renders', (WidgetTester tester) async {
    await tester.pumpWidget(const PastelStoreApp());

    expect(find.text('pastel store'), findsOneWidget);
    expect(find.text('Explore products'), findsOneWidget);
  });
}
