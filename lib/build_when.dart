/// A Flutter package that simplifies `BlocBuilder` usage with declarative filters.
///
/// This library provides three widgets that wrap `BlocBuilder` with smart
/// comparison logic:
///
/// - `BuildWhen` - Rebuilds when a single filter value changes
/// - `BuildWhenSome` - Rebuilds when any of the specified filters change
/// - `BuildWhenAll` - Rebuilds only when all of the specified filters change
///
/// All widgets automatically handle comparisons for primitives, null values,
/// and collections (List, Map, Set) using Flutter's built-in equality functions.
///
/// ## Examples
///
/// ### BuildWhen - Single Filter
///
/// Rebuilds only when the specified filter value changes:
///
/// ```dart
/// BuildWhen<UserBloc, UserState>(
///   filter: (state) => state.name,
///   builder: (context, state) => Text('Name: ${state.name}'),
/// )
/// ```
///
/// ### BuildWhenSome - Any Filter Changes
///
/// Rebuilds when **any** of the specified filters change:
///
/// ```dart
/// BuildWhenSome<UserBloc, UserState>(
///   filterSome: [
///     (state) => state.name,
///     (state) => state.age,
///   ],
///   builder: (context, state) => Text('Name: ${state.name}, Age: ${state.age}'),
/// )
/// ```
///
/// ### BuildWhenAll - All Filters Change
///
/// Rebuilds only when **all** of the specified filters change:
///
/// ```dart
/// BuildWhenAll<UserBloc, UserState>(
///   filterAll: [
///     (state) => state.name,
///     (state) => state.age,
///   ],
///   builder: (context, state) => Text('Name: ${state.name}, Age: ${state.age}'),
/// )
/// ```
///
/// ### Comparison with BlocBuilder
///
/// Instead of writing verbose `buildWhen` logic:
///
/// ```dart
/// BlocBuilder<UserBloc, UserState>(
///   buildWhen: (previous, current) => previous.name != current.name,
///   builder: (context, state) => Text('Name: ${state.name}'),
/// )
/// ```
///
/// Use `BuildWhen` with a simple filter:
///
/// ```dart
/// BuildWhen<UserBloc, UserState>(
///   filter: (state) => state.name,
///   builder: (context, state) => Text('Name: ${state.name}'),
/// )
/// ```
library;

export 'src/build_when_base.dart';
