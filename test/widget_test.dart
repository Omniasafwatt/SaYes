import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sayyes/main.dart';

void main() {
  testWidgets('SayYes app boots and shows the design system showcase', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: SayYesApp()));
    await tester.pumpAndSettle();

    expect(find.text('SayYes'), findsOneWidget);
  });
}
