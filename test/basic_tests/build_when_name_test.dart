import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'build_when_test_helper.dart';

void main() {
  testWidgets('build_when_name test', (tester) async {
    final userBloc = await warmUpUserBloc(tester);
    final buildWhenNameFinder = find.byKey(buildWhenNameKey);

    expect(buildWhenNameFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenNameFinder).data, 'Name: John, Age: 20');

    userBloc.add(UserEvent(name: 'Jane'));
    await tester.pumpAndSettle();

    expect(buildWhenNameFinder, findsOneWidget);
    expect(tester.widget<Text>(buildWhenNameFinder).data, 'Name: Jane, Age: 20');

    userBloc.add(UserEvent(age: 21));
    await tester.pumpAndSettle();

    expect(buildWhenNameFinder, findsOneWidget);
    // The age was changed via the UserEvent. But buildWhenNameFinder only rebuilds when the name changes.
    expect(tester.widget<Text>(buildWhenNameFinder).data, 'Name: Jane, Age: 20');
  });
}
