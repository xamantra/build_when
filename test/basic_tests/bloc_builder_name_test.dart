import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'build_when_test_helper.dart';

void main() {
  testWidgets('bloc_builder_name test', (tester) async {
    final userBloc = await warmUpUserBloc(tester);
    final blocBuilderNameFinder = find.byKey(blocBuilderNameKey);

    expect(blocBuilderNameFinder, findsOneWidget);
    expect(tester.widget<Text>(blocBuilderNameFinder).data, 'Name: John, Age: 20');

    userBloc.add(UserEvent(name: 'Jane'));
    await tester.pumpAndSettle();

    expect(blocBuilderNameFinder, findsOneWidget);
    expect(tester.widget<Text>(blocBuilderNameFinder).data, 'Name: Jane, Age: 20');

    userBloc.add(UserEvent(age: 21));
    await tester.pumpAndSettle();

    expect(blocBuilderNameFinder, findsOneWidget);
    // The age was changed via the UserEvent. But blocBuilderNameFinder only rebuilds when the name changes.
    expect(tester.widget<Text>(blocBuilderNameFinder).data, 'Name: Jane, Age: 20');
  });
}
