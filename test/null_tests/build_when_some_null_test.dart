import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'build_when_null_test_helper.dart';

void main() {
  testWidgets('build_when_some null test', (tester) async {
    final nullBloc = await warmUpNullBloc(tester);
    final buildWhenSomeNullFinder = find.byKey(buildWhenSomeNullKey);

    expect(buildWhenSomeNullFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenSomeNullFinder).data, 'Some: Nullable=null');

    // Set nullableString to 'test' - should trigger rebuild (null -> non-null)
    nullBloc.add(NullEvent.nullableString('test'));
    await tester.pumpAndSettle();

    expect(buildWhenSomeNullFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenSomeNullFinder).data, 'Some: Nullable=test');

    // Set nullableString to null - should trigger rebuild (non-null -> null)
    nullBloc.add(NullEvent.nullableString(null));
    await tester.pumpAndSettle();

    expect(buildWhenSomeNullFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenSomeNullFinder).data, 'Some: Nullable=null');
  });
}
