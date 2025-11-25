import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A function that extracts a value from a state to monitor for changes.
///
/// The returned value is used to determine if the widget should rebuild.
/// The comparison handles primitives, null values, and collections automatically.
///
/// Example:
/// ```dart
/// WhenChangeFilter<UserState> nameFilter = (state) => state.name;
/// ```
typedef WhenChangeFilter<S> = Object? Function(S state);

/// A widget that rebuilds only when the specified filter value changes.
///
/// This widget wraps [BlocBuilder] with smart comparison logic. Instead of
/// manually writing `buildWhen: (previous, current) => previous.field != current.field`,
/// you can simply specify what field you care about using the [filter] parameter.
///
/// The widget automatically handles:
/// - Primitive comparisons (strings, numbers, booleans, etc.)
/// - Null value detection
/// - Deep collection comparisons (List, Map, Set) using Flutter's equality functions
///
/// Example:
/// ```dart
/// BuildWhen<UserBloc, UserState>(
///   filter: (state) => state.name,
///   builder: (context, state) => Text('Name: ${state.name}'),
/// )
/// ```
///
/// This is equivalent to:
/// ```dart
/// BlocBuilder<UserBloc, UserState>(
///   buildWhen: (previous, current) => previous.name != current.name,
///   builder: (context, state) => Text('Name: ${state.name}'),
/// )
/// ```
class BuildWhen<B extends BlocBase<S>, S> extends StatelessWidget {
  const BuildWhen({
    required this.builder,
    this.filter,
    this.bloc,
    super.key,
  });

  /// The bloc to listen to.
  ///
  /// If not provided, the widget will use [BlocBuilder]'s default behavior
  /// to find the bloc in the widget tree using [BuildContext].
  final B? bloc;

  /// A function that extracts a value from the state to monitor for changes.
  ///
  /// The widget will rebuild only when the value returned by this function
  /// changes between state updates. If `null`, the widget will rebuild on
  /// every state change.
  ///
  /// The comparison automatically handles primitives, null values, and
  /// collections (List, Map, Set).
  final WhenChangeFilter<S>? filter;

  /// The builder function that creates a widget based on the current state.
  ///
  /// This function is called whenever the widget needs to rebuild, which
  /// happens when the value returned by [filter] changes.
  final Widget Function(BuildContext context, S state) builder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      bloc: bloc,
      buildWhen: (previous, current) {
        final whenChanged = _didWhenChanged(previous, current);
        return whenChanged;
      },
      builder: builder,
    );
  }

  /// Determines if the filtered value changed between two states.
  ///
  /// This method applies the [filter] function to both states and compares
  /// the results. It handles:
  /// - Null values (detects null-to-value and value-to-null changes)
  /// - Collections (List, Map, Set) using Flutter's deep equality functions
  /// - Primitive values using standard equality
  ///
  /// Returns `true` if the filtered value changed, `false` otherwise.
  bool _didWhenChanged(S previous, S current, {WhenChangeFilter<S>? filter}) {
    final a = (filter ?? this.filter)?.call(previous);
    final b = (filter ?? this.filter)?.call(current);

    // Handle null cases first - if one is null and other isn't, they're different
    if (a == null || b == null) {
      return a != b;
    }

    // Both are non-null, check for collection types
    if (a is List && b is List) {
      return !listEquals(a, b);
    }
    if (a is Map && b is Map) {
      return !mapEquals(a, b);
    }
    if (a is Set && b is Set) {
      return !setEquals(a, b);
    }

    return a != b;
  }
}

/// A widget that rebuilds when **any** of the specified filters change.
///
/// This widget wraps [BlocBuilder] and rebuilds whenever at least one of
/// the filters in [filterSome] detects a change. This is useful when you
/// want to rebuild if any of several fields change.
///
/// The widget automatically handles:
/// - Primitive comparisons (strings, numbers, booleans, etc.)
/// - Null value detection
/// - Deep collection comparisons (List, Map, Set) using Flutter's equality functions
///
/// Example:
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
/// This will rebuild if either `name` OR `age` changes.
class BuildWhenSome<B extends BlocBase<S>, S> extends StatelessWidget {
  const BuildWhenSome({
    required this.builder,
    this.filterSome,
    this.bloc,
    super.key,
  });

  /// The bloc to listen to.
  ///
  /// If not provided, the widget will use [BlocBuilder]'s default behavior
  /// to find the bloc in the widget tree using [BuildContext].
  final B? bloc;

  /// A list of functions that extract values from the state to monitor for changes.
  ///
  /// The widget will rebuild when **any** of these filters detect a change.
  /// If `null` or empty, the widget will rebuild on every state change.
  ///
  /// Each filter's comparison automatically handles primitives, null values,
  /// and collections (List, Map, Set).
  final List<WhenChangeFilter<S>>? filterSome;

  /// The builder function that creates a widget based on the current state.
  ///
  /// This function is called whenever the widget needs to rebuild, which
  /// happens when any value returned by the filters in [filterSome] changes.
  final Widget Function(BuildContext context, S state) builder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      bloc: bloc,
      buildWhen: (previous, current) {
        final filters = filterSome ?? [];
        if (filters.isEmpty) return true; // Rebuild on every change when no filters provided
        final whenSomeChanged = filters.map((filter) => _didWhenChanged(previous, current, filter: filter)).any((x) => x);
        return whenSomeChanged;
      },
      builder: builder,
    );
  }

  /// Determines if the filtered value changed between two states.
  ///
  /// This method applies the [filter] function to both states and compares
  /// the results. It handles:
  /// - Null values (detects null-to-value and value-to-null changes)
  /// - Collections (List, Map, Set) using Flutter's deep equality functions
  /// - Primitive values using standard equality
  ///
  /// Returns `true` if the filtered value changed, `false` otherwise.
  bool _didWhenChanged(S previous, S current, {WhenChangeFilter<S>? filter}) {
    final a = filter?.call(previous);
    final b = filter?.call(current);

    // Handle null cases first - if one is null and other isn't, they're different
    if (a == null || b == null) {
      return a != b;
    }

    // Both are non-null, check for collection types
    if (a is List && b is List) {
      return !listEquals(a, b);
    }
    if (a is Map && b is Map) {
      return !mapEquals(a, b);
    }
    if (a is Set && b is Set) {
      return !setEquals(a, b);
    }

    return a != b;
  }
}

/// A widget that rebuilds only when **all** of the specified filters change.
///
/// This widget wraps [BlocBuilder] and rebuilds only when every filter in
/// [filterAll] detects a change. This is useful when you want to rebuild
/// only when multiple specific conditions are met simultaneously.
///
/// The widget automatically handles:
/// - Primitive comparisons (strings, numbers, booleans, etc.)
/// - Null value detection
/// - Deep collection comparisons (List, Map, Set) using Flutter's equality functions
///
/// Example:
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
/// This will rebuild only if both `name` AND `age` change.
class BuildWhenAll<B extends BlocBase<S>, S> extends StatelessWidget {
  const BuildWhenAll({
    required this.builder,
    this.filterAll,
    this.bloc,
    super.key,
  });

  /// The bloc to listen to.
  ///
  /// If not provided, the widget will use [BlocBuilder]'s default behavior
  /// to find the bloc in the widget tree using [BuildContext].
  final B? bloc;

  /// A list of functions that extract values from the state to monitor for changes.
  ///
  /// The widget will rebuild only when **all** of these filters detect a change.
  /// If `null` or empty, the widget will rebuild on every state change.
  ///
  /// Each filter's comparison automatically handles primitives, null values,
  /// and collections (List, Map, Set).
  final List<WhenChangeFilter<S>>? filterAll;

  /// The builder function that creates a widget based on the current state.
  ///
  /// This function is called whenever the widget needs to rebuild, which
  /// happens when all values returned by the filters in [filterAll] change.
  final Widget Function(BuildContext context, S state) builder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      bloc: bloc,
      buildWhen: (previous, current) {
        final filters = filterAll ?? [];
        if (filters.isEmpty) return true; // Rebuild on every change when no filters provided
        final whenAllChanged = filters.map((filter) => _didWhenChanged(previous, current, filter: filter)).every((x) => x);
        return whenAllChanged;
      },
      builder: builder,
    );
  }

  /// Determines if the filtered value changed between two states.
  ///
  /// This method applies the [filter] function to both states and compares
  /// the results. It handles:
  /// - Null values (detects null-to-value and value-to-null changes)
  /// - Collections (List, Map, Set) using Flutter's deep equality functions
  /// - Primitive values using standard equality
  ///
  /// Returns `true` if the filtered value changed, `false` otherwise.
  bool _didWhenChanged(S previous, S current, {WhenChangeFilter<S>? filter}) {
    final a = filter?.call(previous);
    final b = filter?.call(current);

    // Handle null cases first - if one is null and other isn't, they're different
    if (a == null || b == null) {
      return a != b;
    }

    // Both are non-null, check for collection types
    if (a is List && b is List) {
      return !listEquals(a, b);
    }
    if (a is Map && b is Map) {
      return !mapEquals(a, b);
    }
    if (a is Set && b is Set) {
      return !setEquals(a, b);
    }

    return a != b;
  }
}
