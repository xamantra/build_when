# build_when

The better way to use `BlocBuilder` - simplify your `buildWhen` logic with declarative filters.

[![codecov](https://codecov.io/gh/xamantra/build_when/graph/badge.svg?token=DTTgXhtiqs)](https://codecov.io/gh/xamantra/build_when)
![GitHub License](https://img.shields.io/github/license/xamantra/build_when)

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

## Why not just use BlocSelector?

`BlocSelector` achieves similar filtering, but there's an important difference:

- **BlocSelector** only passes the filtered value to the builder, not the full state
- **BuildWhen** passes the complete state, giving you access to all state properties

```dart
// BlocSelector - builder only receives the filtered value
BlocSelector<UserBloc, UserState, String>(
  selector: (state) => state.name,
  builder: (context, name) => Text('Name: $name'), // Only has access to 'name'
)

// BuildWhen - builder receives the full state
BuildWhen<UserBloc, UserState>(
  filter: (state) => state.name,
  builder: (context, state) => Text('Name: ${state.name}, Age: ${state.age}'), // Full state access
)
```

Use `BuildWhen` when you need access to the full state while only rebuilding on specific changes.

## License

MIT
