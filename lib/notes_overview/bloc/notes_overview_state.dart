part of 'notes_overview_bloc.dart';

enum NotesOverviewStatus { loading, loaded, error }

final class NotesOverviewState extends Equatable {
  const NotesOverviewState({
    this.status = NotesOverviewStatus.loading,
    this.notes = const IList<Note>.empty(),
    this.message = '',
    this.lastDeletedNote = const Note.empty(),
    this.inputField = '',
    this.isDarkTheme = false,
    this.editingNoteId = 0,
    this.filteredNotes = const IList<Note>.empty(),
  });

  final NotesOverviewStatus status;
  final IList<Note> notes;
  final int editingNoteId;
  final Note lastDeletedNote;
  final String message;
  final String inputField;
  final bool isDarkTheme;
  final IList<Note> filteredNotes;

  NotesOverviewState copyWith({
    NotesOverviewStatus? status,
    IList<Note>? notes,
    Note? lastDeletedNote,
    String? message,
    String? inputField,
    int? editingNoteId,
    IList<Note>? filteredNotes,
  }) {
    return NotesOverviewState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      lastDeletedNote: lastDeletedNote ?? this.lastDeletedNote,
      message: message ?? this.message,
      inputField: inputField ?? this.inputField,
      editingNoteId: editingNoteId ?? this.editingNoteId,
      filteredNotes: filteredNotes ?? this.filteredNotes,
    );
  }

  @override
  List<Object> get props => [
        status,
        notes,
        message,
        lastDeletedNote,
        inputField,
        editingNoteId,
        filteredNotes,
      ];
}
