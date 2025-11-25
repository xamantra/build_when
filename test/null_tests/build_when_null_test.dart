import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'build_when_null_test_helper.dart';

void main() {
  testWidgets('build_when null test', (tester) async {
    final nullBloc = await warmUpNullBloc(tester);
    final buildWhenNullFinder = find.byKey(buildWhenNullKey);

    expect(buildWhenNullFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenNullFinder).data, 'Nullable: null');

    // Set nullableString to 'test' - should trigger rebuild (null -> non-null)
    nullBloc.add(NullEvent.nullableString('test'));
    await tester.pumpAndSettle();

    expect(buildWhenNullFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenNullFinder).data, 'Nullable: test');

    // Set nullableString to null - should trigger rebuild (non-null -> null)
    nullBloc.add(NullEvent.nullableString(null));
    await tester.pumpAndSettle();

    expect(buildWhenNullFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenNullFinder).data, 'Nullable: null');

    // Set nullableString to 'test' again - should trigger rebuild (null -> non-null)
    nullBloc.add(NullEvent.nullableString('test'));
    await tester.pumpAndSettle();

    expect(buildWhenNullFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenNullFinder).data, 'Nullable: test');

    // Set nullableString to same value 'test' - should NOT trigger rebuild
    nullBloc.add(NullEvent.nullableString('test'));
    await tester.pumpAndSettle();

    expect(buildWhenNullFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenNullFinder).data, 'Nullable: test');
  });
}
