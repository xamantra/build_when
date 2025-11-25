import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'build_when_test_helper.dart';

void main() {
  testWidgets('bloc_builder_name_age test', (tester) async {
    final userBloc = await warmUpUserBloc(tester);
    final blocBuilderNameAgeFinder = find.byKey(blocBuilderNameAgeKey);

    expect(blocBuilderNameAgeFinder, findsOneWidget);
    expect(tester.widget<Text>(blocBuilderNameAgeFinder).data, 'Name: John, Age: 20');

    // Changing name should trigger rebuild
    userBloc.add(UserEvent(name: 'Jane'));
    await tester.pumpAndSettle();

    expect(blocBuilderNameAgeFinder, findsOneWidget);
    expect(tester.widget<Text>(blocBuilderNameAgeFinder).data, 'Name: Jane, Age: 20');

    // Changing age should also trigger rebuild (buildWhen uses OR condition)
    userBloc.add(UserEvent(age: 21));
    await tester.pumpAndSettle();

    expect(blocBuilderNameAgeFinder, findsOneWidget);
    expect(tester.widget<Text>(blocBuilderNameAgeFinder).data, 'Name: Jane, Age: 21');
  });
}
