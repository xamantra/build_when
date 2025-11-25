import 'package:build_when/build_when.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class UserState {
  final String name;
  final int age;

  UserState({
    required this.name,
    required this.age,
  });
}

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState(name: 'John', age: 20)) {
    on<UserEvent>((event, emit) {
      emit(UserState(name: event.name ?? state.name, age: event.age ?? state.age));
    });
  }
}

class UserEvent {
  final String? name;
  final int? age;

  UserEvent({
    this.name,
    this.age,
  });
}

const testWidth = 1920.0;
const testHeight = 1920.0;

class AppMain extends StatelessWidget {
  const AppMain({
    required this.userBloc,
    super.key,
  });

  final UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => userBloc),
        ],
        child: const SizedBox(
          width: testWidth,
          height: testHeight,
          child: UserWidget(),
        ),
      ),
    );
  }
}

const buildWhenNameKey = ValueKey<String>('build_when_name_key');
const blocBuilderNameKey = ValueKey<String>('bloc_builder_name_key');
const blocSelectorNameKey = ValueKey<String>('bloc_selector_name_key');
const buildWhenSomeNameAgeKey = ValueKey<String>('build_when_some_name_age_key');
const blocBuilderNameAgeKey = ValueKey<String>('bloc_builder_name_age_key');
const buildWhenAllNameAgeKey = ValueKey<String>('build_when_all_name_age_key');
const blocBuilderAllNameAgeKey = ValueKey<String>('bloc_builder_all_name_age_key');

class UserWidget extends StatelessWidget {
  const UserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildWhen<UserBloc, UserState>(
          filter: (state) => state.name, // Identical behavior to `buildWhen: (previous, current) => previous.name != current.name,`
          builder: (context, state) {
            return Text(
              key: buildWhenNameKey,
              'Name: ${state.name}, Age: ${state.age}',
            );
          },
        ),
        // Compared to original BlocBuilder
        BlocBuilder<UserBloc, UserState>(
          buildWhen: (previous, current) => previous.name != current.name,
          builder: (context, state) {
            return Text(
              key: blocBuilderNameKey,
              'Name: ${state.name}, Age: ${state.age}',
            );
          },
        ),
        // BlocSelector actually already tries to solve this friction from BlocBuilder, but it only provides value access of the filtered state. In this case, we filtered $name so we only have access to the $name state. What if you need to filter $name change but your widget needs to access the $age state for UI as well?
        // BuildWhen attempts to solve both: shorten "buildWhen" friction via filter selector, and full access to the state via builder.
        BlocSelector<UserBloc, UserState, String>(
          selector: (state) => state.name,
          builder: (context, name) {
            return Text(
              key: blocSelectorNameKey,
              'Name: $name',
            );
          },
        ),

        // The library also provides a way to filter multiple states at once.
        BuildWhenSome<UserBloc, UserState>(
          filterSome: [
            // filterSome will trigger a rebuild when one of the filters changes.
            (state) => state.name,
            (state) => state.age,
          ],
          builder: (context, state) {
            return Text(
              key: buildWhenSomeNameAgeKey,
              'Name: ${state.name}, Age: ${state.age}',
            );
          },
        ),
        // Compared to original BlocBuilder
        BlocBuilder<UserBloc, UserState>(
          buildWhen: (previous, current) => previous.name != current.name || previous.age != current.age,
          builder: (context, state) {
            return Text(
              key: blocBuilderNameAgeKey,
              'Name: ${state.name}, Age: ${state.age}',
            );
          },
        ),

        // The library also provides a way to filter all states at once.
        BuildWhenAll<UserBloc, UserState>(
          filterAll: [
            // filterAll will trigger a rebuild only when all of the filters change at once.
            (state) => state.name,
            (state) => state.age,
          ],
          builder: (context, state) {
            return Text(
              key: buildWhenAllNameAgeKey,
              'Name: ${state.name}, Age: ${state.age}',
            );
          },
        ),
        // Compared to original BlocBuilder
        BlocBuilder<UserBloc, UserState>(
          buildWhen: (previous, current) => previous.name != current.name && previous.age != current.age,
          builder: (context, state) {
            return Text(
              key: blocBuilderAllNameAgeKey,
              'Name: ${state.name}, Age: ${state.age}',
            );
          },
        ),
      ],
    );
  }
}

Future<UserBloc> warmUpUserBloc(WidgetTester tester) async {
  tester.view.physicalSize = const Size(testWidth, testHeight);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() => tester.view.resetPhysicalSize());
  addTearDown(() => tester.view.resetDevicePixelRatio());

  final userBloc = UserBloc();
  await tester.pumpWidget(AppMain(userBloc: userBloc));
  await tester.pumpAndSettle();

  return userBloc;
}
