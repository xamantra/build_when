import 'package:build_when/build_when.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class NullState {
  final String? nullableString;

  NullState({
    this.nullableString,
  });
}

class NullEvent {
  final String? nullableString;
  final bool _nullableStringSet;

  NullEvent({
    this.nullableString,
    bool nullableStringSet = false,
  }) : _nullableStringSet = nullableStringSet;

  NullEvent.nullableString(String? value) : this(nullableString: value, nullableStringSet: true);
}

class NullBloc extends Bloc<NullEvent, NullState> {
  NullBloc() : super(NullState()) {
    on<NullEvent>((event, emit) {
      emit(
        NullState(
          nullableString: event._nullableStringSet ? event.nullableString : state.nullableString,
        ),
      );
    });
  }
}

const testWidth = 1920.0;
const testHeight = 1920.0;

class NullAppMain extends StatelessWidget {
  const NullAppMain({
    required this.nullBloc,
    super.key,
  });

  final NullBloc nullBloc;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => nullBloc),
        ],
        child: const SizedBox(
          width: testWidth,
          height: testHeight,
          child: NullWidget(),
        ),
      ),
    );
  }
}

const buildWhenNullKey = ValueKey<String>('build_when_null_key');
const buildWhenSomeNullKey = ValueKey<String>('build_when_some_null_key');
const buildWhenAllNullKey = ValueKey<String>('build_when_all_null_key');

class NullWidget extends StatelessWidget {
  const NullWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // BuildWhen with nullable filter
        BuildWhen<NullBloc, NullState>(
          filter: (state) => state.nullableString,
          builder: (context, state) {
            return Text(
              key: buildWhenNullKey,
              'Nullable: ${state.nullableString}',
            );
          },
        ),
        // BuildWhenSome with nullable filters
        BuildWhenSome<NullBloc, NullState>(
          filterSome: [
            (state) => state.nullableString,
          ],
          builder: (context, state) {
            return Text(
              key: buildWhenSomeNullKey,
              'Some: Nullable=${state.nullableString}',
            );
          },
        ),
        // BuildWhenAll with nullable filters
        BuildWhenAll<NullBloc, NullState>(
          filterAll: [
            (state) => state.nullableString,
          ],
          builder: (context, state) {
            return Text(
              key: buildWhenAllNullKey,
              'All: Nullable=${state.nullableString}',
            );
          },
        ),
      ],
    );
  }
}

Future<NullBloc> warmUpNullBloc(WidgetTester tester) async {
  tester.view.physicalSize = const Size(testWidth, testHeight);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() => tester.view.resetPhysicalSize());
  addTearDown(() => tester.view.resetDevicePixelRatio());

  final nullBloc = NullBloc();
  await tester.pumpWidget(NullAppMain(nullBloc: nullBloc));
  await tester.pumpAndSettle();

  return nullBloc;
}
