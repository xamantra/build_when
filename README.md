# build_when

The better way to use `BlocBuilder` - simplify your `buildWhen` logic with declarative filters.

## Features

- 🎯 **Declarative filters** - Just specify what you care about, not how to compare it
- 🔄 **Smart comparisons** - Automatically handles primitives, nulls, and collections (List, Map, Set)
- 📦 **Three variants** - `BuildWhen`, `BuildWhenSome`, and `BuildWhenAll` for different use cases
- 🚀 **Zero boilerplate** - No more manual `previous.field != current.field` comparisons

## Installation

Add `build_when` to your `pubspec.yaml`:

```yaml
dependencies:
   build_when: ^0.1.0
```

## Usage

### Basic Example

Instead of writing verbose `buildWhen` logic:

```dart
// ❌ Verbose BlocBuilder
BlocBuilder<UserBloc, UserState>(
  buildWhen: (previous, current) => previous.name != current.name,
  builder: (context, state) => Text('Name: ${state.name}'),
)
```

Use `BuildWhen` with a simple filter:

```dart
// ✅ Clean BuildWhen
BuildWhen<UserBloc, UserState>(
  filter: (state) => state.name,
  builder: (context, state) => Text('Name: ${state.name}'),
)
```

### BuildWhen - Single Filter

Rebuilds only when the specified filter value changes:

```dart
BuildWhen<UserBloc, UserState>(
  filter: (state) => state.name,
  builder: (context, state) => Text('Name: ${state.name}'),
)
```

### BuildWhenSome - Any Filter Changes

Rebuilds when **any** of the specified filters change:

```dart
BuildWhenSome<UserBloc, UserState>(
  filterSome: [
    (state) => state.name,
    (state) => state.age,
  ],
  builder: (context, state) => Text('Name: ${state.name}, Age: ${state.age}'),
)
```

### BuildWhenAll - All Filters Change

Rebuilds only when **all** of the specified filters change:

```dart
BuildWhenAll<UserBloc, UserState>(
  filterAll: [
    (state) => state.name,
    (state) => state.age,
  ],
  builder: (context, state) => Text('Name: ${state.name}, Age: ${state.age}'),
)
```

## Smart Comparisons

`build_when` automatically handles:

- **Primitives** - Strings, numbers, booleans, etc.
- **Null values** - Properly detects null-to-value and value-to-null changes
- **Collections** - Uses Flutter's `listEquals`, `mapEquals`, and `setEquals` for deep comparison

```dart
// Works with collections too!
BuildWhen<UserBloc, UserState>(
  filter: (state) => state.items, // List<String>
  builder: (context, state) => Text('Items: ${state.items.length}'),
)
```

## Complete Example

```dart
import 'package:build_when/build_when.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class ExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Rebuild only when name changes
          BuildWhen<UserBloc, UserState>(
            filter: (state) => state.name,
            builder: (context, state) => Text('Name: ${state.name}'),
          ),
          
          // Rebuild when name OR age changes
          BuildWhenSome<UserBloc, UserState>(
            filterSome: [
              (state) => state.name,
              (state) => state.age,
            ],
            builder: (context, state) => Text('Name: ${state.name}, Age: ${state.age}'),
          ),
        ],
      ),
    );
  }
}
```

## License

MIT
