import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'build_when_test_helper.dart';

void main() {
  testWidgets('build_when_some_name_age test', (tester) async {
    final userBloc = await warmUpUserBloc(tester);
    final buildWhenSomeNameAgeFinder = find.byKey(buildWhenSomeNameAgeKey);

    expect(buildWhenSomeNameAgeFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenSomeNameAgeFinder).data, 'Name: John, Age: 20');

    // Changing name should trigger rebuild
    userBloc.add(UserEvent(name: 'Jane'));
    await tester.pumpAndSettle();

    expect(buildWhenSomeNameAgeFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenSomeNameAgeFinder).data, 'Name: Jane, Age: 20');

    // Changing age should also trigger rebuild (filterSome rebuilds when ANY filter changes)
    userBloc.add(UserEvent(age: 21));
    await tester.pumpAndSettle();

    expect(buildWhenSomeNameAgeFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenSomeNameAgeFinder).data, 'Name: Jane, Age: 21');
  });
}
