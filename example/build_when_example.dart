import 'package:build_when/build_when.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Example state and bloc
class UserState {
  final String name;
  final int age;

  UserState({required this.name, required this.age});

  UserState copyWith({String? name, int? age}) {
    return UserState(
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }
}

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState(name: 'John', age: 25)) {
    on<UserEvent>((event, emit) {
      emit(state.copyWith(name: event.name, age: event.age));
    });
  }
}

class UserEvent {
  final String? name;
  final int? age;
  UserEvent({this.name, this.age});
}

void main() {
  runApp(
    MaterialApp(
      home: BlocProvider(
        create: (_) => UserBloc(),
        child: const ExamplePage(),
      ),
    ),
  );
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BuildWhen Examples')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Example 1: BuildWhen - rebuild only when name changes
            const Text('1. BuildWhen (single filter)', style: TextStyle(fontWeight: FontWeight.bold)),
            BuildWhen<UserBloc, UserState>(
              filter: (state) => state.name,
              builder: (context, state) => Text('Name: ${state.name}, Age: ${state.age}'),
            ),
            const SizedBox(height: 16),

            // Example 2: BuildWhenSome - rebuild when ANY filter changes
            const Text('2. BuildWhenSome (any filter)', style: TextStyle(fontWeight: FontWeight.bold)),
            BuildWhenSome<UserBloc, UserState>(
              filterSome: [
                (state) => state.name,
                (state) => state.age,
              ],
              builder: (context, state) => Text('Name: ${state.name}, Age: ${state.age}'),
            ),
            const SizedBox(height: 16),

            // Example 3: BuildWhenAll - rebuild only when ALL filters change
            const Text('3. BuildWhenAll (all filters)', style: TextStyle(fontWeight: FontWeight.bold)),
            BuildWhenAll<UserBloc, UserState>(
              filterAll: [
                (state) => state.name,
                (state) => state.age,
              ],
              builder: (context, state) => Text('Name: ${state.name}, Age: ${state.age}'),
            ),
            const SizedBox(height: 24),

            // Comparison with BlocBuilder
            const Text('Comparison with BlocBuilder:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('BuildWhen:', style: TextStyle(fontStyle: FontStyle.italic)),
            BuildWhen<UserBloc, UserState>(
              filter: (state) => state.name,
              builder: (context, state) => Text('Name: ${state.name}'),
            ),
            const SizedBox(height: 8),
            const Text('BlocBuilder (equivalent):', style: TextStyle(fontStyle: FontStyle.italic)),
            BlocBuilder<UserBloc, UserState>(
              buildWhen: (previous, current) => previous.name != current.name,
              builder: (context, state) => Text('Name: ${state.name}'),
            ),
          ],
        ),
      ),
    );
  }
}
