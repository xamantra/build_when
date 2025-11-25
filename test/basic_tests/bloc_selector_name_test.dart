import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'build_when_test_helper.dart';

void main() {
  testWidgets('bloc_selector_name test', (tester) async {
    final userBloc = await warmUpUserBloc(tester);
    final blocSelectorNameFinder = find.byKey(blocSelectorNameKey);

    expect(blocSelectorNameFinder, findsOneWidget);
    expect(tester.widget<Text>(blocSelectorNameFinder).data, 'Name: John');

    userBloc.add(UserEvent(name: 'Jane'));
    await tester.pumpAndSettle();

    expect(blocSelectorNameFinder, findsOneWidget);
    expect(tester.widget<Text>(blocSelectorNameFinder).data, 'Name: Jane');

    userBloc.add(UserEvent(age: 21));
    await tester.pumpAndSettle();

    expect(blocSelectorNameFinder, findsOneWidget);
    // The age was changed via the UserEvent. But blocSelectorNameFinder only rebuilds when the name changes.
    expect(tester.widget<Text>(blocSelectorNameFinder).data, 'Name: Jane');
  });
}
