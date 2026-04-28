import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hair_preview/main.dart';

void main() {
  testWidgets('hair consultation app loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: HairConsultationApp(),
      ),
    );

    expect(find.byType(HairConsultationApp), findsOneWidget);
  });
}