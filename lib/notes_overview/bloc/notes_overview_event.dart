part of 'notes_overview_bloc.dart';

sealed class NotesOverviewEvent extends Equatable {
  const NotesOverviewEvent();

  @override
  List<Object> get props => [];
}

final class NotesOverviewSubscriptionRequest extends NotesOverviewEvent {
  const NotesOverviewSubscriptionRequest();
}

final class NotesOverviewInputFieldChanged extends NotesOverviewEvent {
  const NotesOverviewInputFieldChanged(this.text);

  final String text;

  @override
  List<Object> get props => [text];
}

final class NotesOverviewNoteAdd extends NotesOverviewEvent {
  const NotesOverviewNoteAdd();
}

final class NotesOverviewNoteUpdate extends NotesOverviewEvent {
  const NotesOverviewNoteUpdate();
}

final class NotesOverviewNoteEdit extends NotesOverviewEvent {
  const NotesOverviewNoteEdit(this.note);

  final Note note;

  @override
  List<Object> get props => [note];
}

final class NotesOverviewNoteEditCancel extends NotesOverviewEvent {
  const NotesOverviewNoteEditCancel();
}

final class NotesOverviewNoteDelete extends NotesOverviewEvent {
  const NotesOverviewNoteDelete(this.id);

  final int id;

  @override
  List<Object> get props => [id];
}

final class NotesOverviewToClipboard extends NotesOverviewEvent {
  const NotesOverviewToClipboard(this.text);

  final String text;

  @override
  List<Object> get props => [text];
}

final class NotesOverviewToggleTheme extends NotesOverviewEvent {
  const NotesOverviewToggleTheme();
}

final class NotesOverviewDatePick extends NotesOverviewEvent {
  const NotesOverviewDatePick(this.datePicked);

  final DateTime datePicked;

  @override
  List<Object> get props => [datePicked];
}

final class NotesOverviewDatePickEnd extends NotesOverviewEvent {
  const NotesOverviewDatePickEnd();
}

final class NotesOverviewSearchStart extends NotesOverviewEvent {
  const NotesOverviewSearchStart();
}

final class NotesOverviewSearchEnd extends NotesOverviewEvent {
  const NotesOverviewSearchEnd();
}

final class NotesOverviewSearchQuery extends NotesOverviewEvent {
  const NotesOverviewSearchQuery(this.query);

  final String query;

  @override
  List<Object> get props => [query];
}
