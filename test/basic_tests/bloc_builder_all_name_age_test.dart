import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'build_when_test_helper.dart';

void main() {
  testWidgets('bloc_builder_all_name_age test', (tester) async {
    final userBloc = await warmUpUserBloc(tester);
    final blocBuilderAllNameAgeFinder = find.byKey(blocBuilderAllNameAgeKey);

    expect(blocBuilderAllNameAgeFinder, findsOneWidget);
    expect(tester.widget<Text>(blocBuilderAllNameAgeFinder).data, 'Name: John, Age: 20');

    // Changing only name should NOT trigger rebuild (buildWhen uses AND condition)
    userBloc.add(UserEvent(name: 'Jane'));
    await tester.pumpAndSettle();

    expect(blocBuilderAllNameAgeFinder, findsOneWidget);
    expect(tester.widget<Text>(blocBuilderAllNameAgeFinder).data, 'Name: John, Age: 20');

    // Changing only age should NOT trigger rebuild
    userBloc.add(UserEvent(age: 21));
    await tester.pumpAndSettle();

    expect(blocBuilderAllNameAgeFinder, findsOneWidget);
    expect(tester.widget<Text>(blocBuilderAllNameAgeFinder).data, 'Name: John, Age: 20');

    // Changing both name and age should trigger rebuild
    userBloc.add(UserEvent(name: 'Alice', age: 25));
    await tester.pumpAndSettle();

    expect(blocBuilderAllNameAgeFinder, findsOneWidget);
    expect(tester.widget<Text>(blocBuilderAllNameAgeFinder).data, 'Name: Alice, Age: 25');
  });
}
