import 'package:flutter_test/flutter_test.dart';

import 'package:yaad_sahayak/main.dart';

void main() {
  testWidgets('Yaad Sahayak app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const YaadSahayakApp());

    expect(find.byType(YaadSahayakApp), findsOneWidget);
  });
}