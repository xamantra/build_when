import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'build_when_collection_test_helper.dart';

void main() {
  testWidgets('build_when_some collection test - List and Map', (tester) async {
    final collectionBloc = await warmUpCollectionBloc(tester);
    final buildWhenSomeListMapFinder = find.byKey(buildWhenSomeListMapKey);

    expect(buildWhenSomeListMapFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenSomeListMapFinder).data, 'Some: List=null, Map=null');

    // Set list to [1, 2, 3] - should trigger rebuild (one filter changed)
    collectionBloc.add(CollectionEvent(list: [1, 2, 3]));
    await tester.pumpAndSettle();

    expect(buildWhenSomeListMapFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenSomeListMapFinder).data, 'Some: List=[1, 2, 3], Map=null');

    // Set list to same [1, 2, 3] - should NOT trigger rebuild (listEquals)
    collectionBloc.add(CollectionEvent(list: [1, 2, 3]));
    await tester.pumpAndSettle();

    expect(buildWhenSomeListMapFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenSomeListMapFinder).data, 'Some: List=[1, 2, 3], Map=null');

    // Set map to {'a': 1} - should trigger rebuild (one filter changed)
    collectionBloc.add(CollectionEvent(list: [1, 2, 3], map: {'a': 1}));
    await tester.pumpAndSettle();

    expect(buildWhenSomeListMapFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenSomeListMapFinder).data, 'Some: List=[1, 2, 3], Map={a: 1}');

    // Set map to same {'a': 1} - should NOT trigger rebuild (mapEquals)
    collectionBloc.add(CollectionEvent(list: [1, 2, 3], map: {'a': 1}));
    await tester.pumpAndSettle();

    expect(buildWhenSomeListMapFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenSomeListMapFinder).data, 'Some: List=[1, 2, 3], Map={a: 1}');
  });

  testWidgets('build_when_some collection test - Set comparison', (tester) async {
    final collectionBloc = await warmUpCollectionBloc(tester);
    final buildWhenSomeSetFinder = find.byKey(buildWhenSomeSetKey);

    expect(buildWhenSomeSetFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenSomeSetFinder).data, 'Some: Set=null');

    // Set set to {1, 2, 3} - should trigger rebuild
    collectionBloc.add(CollectionEvent(set: {1, 2, 3}));
    await tester.pumpAndSettle();

    expect(buildWhenSomeSetFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenSomeSetFinder).data, 'Some: Set={1, 2, 3}');

    // Set set to same values {1, 2, 3} - should NOT trigger rebuild (setEquals)
    collectionBloc.add(CollectionEvent(set: {1, 2, 3}));
    await tester.pumpAndSettle();

    expect(buildWhenSomeSetFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenSomeSetFinder).data, 'Some: Set={1, 2, 3}');

    // Set set to different values {1, 2, 4} - should trigger rebuild
    collectionBloc.add(CollectionEvent(set: {1, 2, 4}));
    await tester.pumpAndSettle();

    expect(buildWhenSomeSetFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenSomeSetFinder).data, 'Some: Set={1, 2, 4}');
  });
}
