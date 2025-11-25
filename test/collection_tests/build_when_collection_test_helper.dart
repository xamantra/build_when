import 'package:build_when/build_when.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class CollectionState {
  final List<int>? list;
  final Map<String, int>? map;
  final Set<int>? set;

  CollectionState({
    this.list,
    this.map,
    this.set,
  });
}

class CollectionEvent {
  final List<int>? list;
  final Map<String, int>? map;
  final Set<int>? set;

  CollectionEvent({
    this.list,
    this.map,
    this.set,
  });
}

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  CollectionBloc() : super(CollectionState()) {
    on<CollectionEvent>((event, emit) {
      emit(
        CollectionState(
          list: event.list ?? state.list,
          map: event.map ?? state.map,
          set: event.set ?? state.set,
        ),
      );
    });
  }
}

const testWidth = 1920.0;
const testHeight = 1920.0;

class CollectionAppMain extends StatelessWidget {
  const CollectionAppMain({
    required this.collectionBloc,
    super.key,
  });

  final CollectionBloc collectionBloc;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => collectionBloc),
        ],
        child: const SizedBox(
          width: testWidth,
          height: testHeight,
          child: CollectionWidget(),
        ),
      ),
    );
  }
}

const buildWhenListKey = ValueKey<String>('build_when_list_key');
const buildWhenMapKey = ValueKey<String>('build_when_map_key');
const buildWhenSetKey = ValueKey<String>('build_when_set_key');
const buildWhenSomeListMapKey = ValueKey<String>('build_when_some_list_map_key');
const buildWhenAllListMapKey = ValueKey<String>('build_when_all_list_map_key');
const buildWhenSomeSetKey = ValueKey<String>('build_when_some_set_key');
const buildWhenAllSetKey = ValueKey<String>('build_when_all_set_key');

class CollectionWidget extends StatelessWidget {
  const CollectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // BuildWhen with List filter
        BuildWhen<CollectionBloc, CollectionState>(
          filter: (state) => state.list,
          builder: (context, state) {
            return Text(
              key: buildWhenListKey,
              'List: ${state.list}',
            );
          },
        ),
        // BuildWhen with Map filter
        BuildWhen<CollectionBloc, CollectionState>(
          filter: (state) => state.map,
          builder: (context, state) {
            return Text(
              key: buildWhenMapKey,
              'Map: ${state.map}',
            );
          },
        ),
        // BuildWhen with Set filter
        BuildWhen<CollectionBloc, CollectionState>(
          filter: (state) => state.set,
          builder: (context, state) {
            return Text(
              key: buildWhenSetKey,
              'Set: ${state.set}',
            );
          },
        ),
        // BuildWhenSome with List and Map filters
        BuildWhenSome<CollectionBloc, CollectionState>(
          filterSome: [
            (state) => state.list,
            (state) => state.map,
          ],
          builder: (context, state) {
            return Text(
              key: buildWhenSomeListMapKey,
              'Some: List=${state.list}, Map=${state.map}',
            );
          },
        ),
        // BuildWhenAll with List and Map filters
        BuildWhenAll<CollectionBloc, CollectionState>(
          filterAll: [
            (state) => state.list,
            (state) => state.map,
          ],
          builder: (context, state) {
            return Text(
              key: buildWhenAllListMapKey,
              'All: List=${state.list}, Map=${state.map}',
            );
          },
        ),
        // BuildWhenSome with Set filter
        BuildWhenSome<CollectionBloc, CollectionState>(
          filterSome: [
            (state) => state.set,
          ],
          builder: (context, state) {
            return Text(
              key: buildWhenSomeSetKey,
              'Some: Set=${state.set}',
            );
          },
        ),
        // BuildWhenAll with Set filter
        BuildWhenAll<CollectionBloc, CollectionState>(
          filterAll: [
            (state) => state.set,
          ],
          builder: (context, state) {
            return Text(
              key: buildWhenAllSetKey,
              'All: Set=${state.set}',
            );
          },
        ),
      ],
    );
  }
}

Future<CollectionBloc> warmUpCollectionBloc(WidgetTester tester) async {
  tester.view.physicalSize = const Size(testWidth, testHeight);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() => tester.view.resetPhysicalSize());
  addTearDown(() => tester.view.resetDevicePixelRatio());

  final collectionBloc = CollectionBloc();
  await tester.pumpWidget(CollectionAppMain(collectionBloc: collectionBloc));
  await tester.pumpAndSettle();

  return collectionBloc;
}
