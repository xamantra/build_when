import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'build_when_collection_test_helper.dart';

void main() {
  testWidgets('build_when collection test - List comparison', (tester) async {
    final collectionBloc = await warmUpCollectionBloc(tester);
    final buildWhenListFinder = find.byKey(buildWhenListKey);

    expect(buildWhenListFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenListFinder).data, 'List: null');

    // Set list to [1, 2, 3] - should trigger rebuild
    collectionBloc.add(CollectionEvent(list: [1, 2, 3]));
    await tester.pumpAndSettle();

    expect(buildWhenListFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenListFinder).data, 'List: [1, 2, 3]');

    // Set list to same values [1, 2, 3] - should NOT trigger rebuild (listEquals)
    collectionBloc.add(CollectionEvent(list: [1, 2, 3]));
    await tester.pumpAndSettle();

    expect(buildWhenListFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenListFinder).data, 'List: [1, 2, 3]');

    // Set list to different values [1, 2, 4] - should trigger rebuild
    collectionBloc.add(CollectionEvent(list: [1, 2, 4]));
    await tester.pumpAndSettle();

    expect(buildWhenListFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenListFinder).data, 'List: [1, 2, 4]');
  });

  testWidgets('build_when collection test - Map comparison', (tester) async {
    final collectionBloc = await warmUpCollectionBloc(tester);
    final buildWhenMapFinder = find.byKey(buildWhenMapKey);

    expect(buildWhenMapFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenMapFinder).data, 'Map: null');

    // Set map to {'a': 1, 'b': 2} - should trigger rebuild
    collectionBloc.add(CollectionEvent(map: {'a': 1, 'b': 2}));
    await tester.pumpAndSettle();

    expect(buildWhenMapFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenMapFinder).data, 'Map: {a: 1, b: 2}');

    // Set map to same values {'a': 1, 'b': 2} - should NOT trigger rebuild (mapEquals)
    collectionBloc.add(CollectionEvent(map: {'a': 1, 'b': 2}));
    await tester.pumpAndSettle();

    expect(buildWhenMapFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenMapFinder).data, 'Map: {a: 1, b: 2}');

    // Set map to different values {'a': 1, 'b': 3} - should trigger rebuild
    collectionBloc.add(CollectionEvent(map: {'a': 1, 'b': 3}));
    await tester.pumpAndSettle();

    expect(buildWhenMapFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenMapFinder).data, 'Map: {a: 1, b: 3}');
  });

  testWidgets('build_when collection test - Set comparison', (tester) async {
    final collectionBloc = await warmUpCollectionBloc(tester);
    final buildWhenSetFinder = find.byKey(buildWhenSetKey);

    expect(buildWhenSetFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenSetFinder).data, 'Set: null');

    // Set set to {1, 2, 3} - should trigger rebuild
    collectionBloc.add(CollectionEvent(set: {1, 2, 3}));
    await tester.pumpAndSettle();

    expect(buildWhenSetFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenSetFinder).data, 'Set: {1, 2, 3}');

    // Set set to same values {1, 2, 3} - should NOT trigger rebuild (setEquals)
    collectionBloc.add(CollectionEvent(set: {1, 2, 3}));
    await tester.pumpAndSettle();

    expect(buildWhenSetFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenSetFinder).data, 'Set: {1, 2, 3}');

    // Set set to different values {1, 2, 4} - should trigger rebuild
    collectionBloc.add(CollectionEvent(set: {1, 2, 4}));
    await tester.pumpAndSettle();

    expect(buildWhenSetFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenSetFinder).data, 'Set: {1, 2, 4}');
  });
}
