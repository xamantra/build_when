import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'build_when_collection_test_helper.dart';

void main() {
  testWidgets('build_when_all collection test - List and Map', (tester) async {
    final collectionBloc = await warmUpCollectionBloc(tester);
    final buildWhenAllListMapFinder = find.byKey(buildWhenAllListMapKey);

    expect(buildWhenAllListMapFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenAllListMapFinder).data, 'All: List=null, Map=null');

    // Set only list to [1, 2, 3] - should NOT trigger rebuild (filterAll requires ALL filters to change)
    collectionBloc.add(CollectionEvent(list: [1, 2, 3]));
    await tester.pumpAndSettle();

    expect(buildWhenAllListMapFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenAllListMapFinder).data, 'All: List=null, Map=null');

    // Set only map to {'a': 1} - should NOT trigger rebuild
    collectionBloc.add(CollectionEvent(map: {'a': 1}));
    await tester.pumpAndSettle();

    expect(buildWhenAllListMapFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenAllListMapFinder).data, 'All: List=null, Map=null');

    // Set both list and map to different values - should trigger rebuild (both filters changed)
    collectionBloc.add(CollectionEvent(list: [1, 2, 4], map: {'a': 2}));
    await tester.pumpAndSettle();

    expect(buildWhenAllListMapFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenAllListMapFinder).data, 'All: List=[1, 2, 4], Map={a: 2}');

    // Set list to same [1, 2, 4] but keep map - should NOT trigger rebuild (listEquals, but map didn't change)
    collectionBloc.add(CollectionEvent(list: [1, 2, 4], map: {'a': 2}));
    await tester.pumpAndSettle();

    expect(buildWhenAllListMapFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenAllListMapFinder).data, 'All: List=[1, 2, 4], Map={a: 2}');

    // Set both to same values - should NOT trigger rebuild (listEquals and mapEquals)
    collectionBloc.add(CollectionEvent(list: [1, 2, 4], map: {'a': 2}));
    await tester.pumpAndSettle();

    expect(buildWhenAllListMapFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenAllListMapFinder).data, 'All: List=[1, 2, 4], Map={a: 2}');

    // Set both to different values - should trigger rebuild (both changed)
    collectionBloc.add(CollectionEvent(list: [1, 2, 5], map: {'a': 3}));
    await tester.pumpAndSettle();

    expect(buildWhenAllListMapFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenAllListMapFinder).data, 'All: List=[1, 2, 5], Map={a: 3}');
  });

  testWidgets('build_when_all collection test - Set comparison', (tester) async {
    final collectionBloc = await warmUpCollectionBloc(tester);
    final buildWhenAllSetFinder = find.byKey(buildWhenAllSetKey);

    expect(buildWhenAllSetFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenAllSetFinder).data, 'All: Set=null');

    // Set set to {1, 2, 3} - should trigger rebuild
    collectionBloc.add(CollectionEvent(set: {1, 2, 3}));
    await tester.pumpAndSettle();

    expect(buildWhenAllSetFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenAllSetFinder).data, 'All: Set={1, 2, 3}');

    // Set set to same values {1, 2, 3} - should NOT trigger rebuild (setEquals)
    collectionBloc.add(CollectionEvent(set: {1, 2, 3}));
    await tester.pumpAndSettle();

    expect(buildWhenAllSetFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenAllSetFinder).data, 'All: Set={1, 2, 3}');

    // Set set to different values {1, 2, 4} - should trigger rebuild
    collectionBloc.add(CollectionEvent(set: {1, 2, 4}));
    await tester.pumpAndSettle();

    expect(buildWhenAllSetFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenAllSetFinder).data, 'All: Set={1, 2, 4}');
  });
}
