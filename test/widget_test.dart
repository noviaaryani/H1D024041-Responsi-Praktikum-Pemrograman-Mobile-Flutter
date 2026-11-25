import 'package:flutter_test/flutter_test.dart';
import 'package:langitku/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LangitKuApp());
  });
}
