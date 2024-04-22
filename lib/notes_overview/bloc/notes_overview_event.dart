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

final class NotesOverviewToClipboard extends NotesOverviewEvent {
  const NotesOverviewToClipboard(this.text);

  final String text;

  @override
  List<Object> get props => [text];
}

final class NotesOverviewToggleTheme extends NotesOverviewEvent {
  const NotesOverviewToggleTheme();
}
