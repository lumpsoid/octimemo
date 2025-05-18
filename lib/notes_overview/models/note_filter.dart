import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:notes_repository/notes_repository.dart';

// Base filter class
@immutable
sealed class NoteFilter {
  const NoteFilter();
  bool apply(Note note);

  // Optional: Add a unique ID to each filter for easier management
  String get id;
}

// Date filter
class DateFilter implements NoteFilter {
  const DateFilter(this.date);
  final DateTime date;

  @override
  bool apply(Note note) {
    return _isSameDate(note.getDateCreated(), date);
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  String get id => 'date_${date.toIso8601String().split('T')[0]}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateFilter &&
          runtimeType == other.runtimeType &&
          _isSameDate(date, other.date);

  @override
  int get hashCode =>
      date.day.hashCode ^ date.month.hashCode ^ date.year.hashCode;
}

// Query filter
class QueryFilter implements NoteFilter {
  const QueryFilter(this.query);
  final String query;

  @override
  bool apply(Note note) {
    return note.body.toLowerCase().contains(query.toLowerCase());
  }

  @override
  String get id => 'query_$query';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryFilter &&
          runtimeType == other.runtimeType &&
          query == other.query;

  @override
  int get hashCode => query.hashCode;
}

// Compound filter
class CompoundFilter implements NoteFilter {
  const CompoundFilter(this.filters);
  final List<NoteFilter> filters;

  @override
  bool apply(Note note) {
    // All filters must match (AND logic)
    return filters.every((filter) => filter.apply(note));
  }

  @override
  String get id => 'compound_${filters.map((f) => f.id).join('_')}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompoundFilter &&
          runtimeType == other.runtimeType &&
          listEquals(filters, other.filters);

  @override
  int get hashCode => Object.hashAll(filters);
}

// Filter manager class
class FilterManager extends ValueNotifier<IMap<Type, NoteFilter>> {
  FilterManager(super.value);

  IMap<Type, NoteFilter> get activeFilters => value;

  // Add or replace a filter by its type
  void setFilter(NoteFilter filter) {
    value = value.add(filter.runtimeType, filter);
  }

  // Remove a filter by type
  void removeFilter(Type filterType) {
    value = value.remove(filterType);
  }

  // Check if a filter type exists
  bool hasFilterType(Type filterType) {
    return value.containsKey(filterType);
  }

  // Get a filter by type
  T? getFilterByType<T extends NoteFilter>() {
    final filter = value[T];
    return filter is T ? filter : null;
  }

  // Apply all active filters to a list of notes
  IList<Note> applyFilters(IList<Note> notes) {
    final filters = value.values.toList();
    if (filters.isEmpty) return notes;

    return notes
        .where(
          (note) => filters.every(
            (filter) => filter.apply(note),
          ),
        )
        .toIList();
  }

  // Clear all filters
  void clearFilters() {
    value = IMap<Type, NoteFilter>();
  }
}
