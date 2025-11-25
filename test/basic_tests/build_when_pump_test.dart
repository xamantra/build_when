import 'package:flutter_test/flutter_test.dart';
import 'build_when_test_helper.dart';

void main() {
  testWidgets('build_when pump test', (tester) async {
    await warmUpUserBloc(tester);

    final buildWhenNameFinder = find.byKey(buildWhenNameKey);
    final blocBuilderNameFinder = find.byKey(blocBuilderNameKey);
    final blocSelectorNameFinder = find.byKey(blocSelectorNameKey);
    final buildWhenSomeNameAgeFinder = find.byKey(buildWhenSomeNameAgeKey);
    final blocBuilderNameAgeFinder = find.byKey(blocBuilderNameAgeKey);
    final buildWhenAllNameAgeFinder = find.byKey(buildWhenAllNameAgeKey);
    final blocBuilderAllNameAgeFinder = find.byKey(blocBuilderAllNameAgeKey);

    expect(buildWhenNameFinder, findsOneWidget);
    expect(blocBuilderNameFinder, findsOneWidget);
    expect(blocSelectorNameFinder, findsOneWidget);
    expect(buildWhenSomeNameAgeFinder, findsOneWidget);
    expect(blocBuilderNameAgeFinder, findsOneWidget);
    expect(buildWhenAllNameAgeFinder, findsOneWidget);
    expect(blocBuilderAllNameAgeFinder, findsOneWidget);
  });
}
