import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_sqflite_api/note_sqflite_api.dart';
import 'package:notes_repository/notes_repository.dart';

part 'notes_overview_event.dart';
part 'notes_overview_state.dart';

class NotesOverviewBloc extends Bloc<NotesOverviewEvent, NotesOverviewState> {
  NotesOverviewBloc({required NotesRepository notesRepository})
      : _notesRepository = notesRepository,
        super(const NotesOverviewState()) {
    on<NotesOverviewSubscriptionRequest>(_onSubscriptionRequest);
    on<NotesOverviewToClipboard>(_onToClipboard);
  }

  final NotesRepository _notesRepository;

  Future<void> _onSubscriptionRequest(
    NotesOverviewSubscriptionRequest event,
    Emitter<NotesOverviewState> emit,
  ) async {
    emit(state.copyWith(status: NotesOverviewStatus.loading));

    await emit.forEach(
      _notesRepository.getNotesStream(),
      onData: (notes) => state.copyWith(
        status: NotesOverviewStatus.loaded,
        notes: notes,
      ),
      onError: (error, stackTrace) => state.copyWith(
        status: NotesOverviewStatus.error,
        message: error.toString(),
      ),
    );
  }

  Future<void> _onToClipboard(
    NotesOverviewToClipboard event,
    Emitter<NotesOverviewState> emit,
  ) async {
    await Clipboard.setData(
      ClipboardData(text: event.text),
    );
    emit(state.copyWith(message: 'Copied to clipboard'));
    emit(state.copyWith(message: ''));
  }
}
