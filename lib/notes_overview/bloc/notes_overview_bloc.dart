import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:notes_repository/notes_repository.dart';

part 'notes_overview_event.dart';
part 'notes_overview_state.dart';

class NotesOverviewBloc extends Bloc<NotesOverviewEvent, NotesOverviewState> {
  NotesOverviewBloc({required NotesRepository notesRepository})
      : _notesRepository = notesRepository,
        super(const NotesOverviewState()) {
    on<NotesOverviewSubscriptionRequest>(_onSubscriptionRequest);
    on<NotesOverviewToClipboard>(_onToClipboard);
    on<NotesOverviewInputFieldChanged>(_onTextChange);
    on<NotesOverviewNoteAdd>(_onNoteAdd);
    on<NotesOverviewNoteEdit>(_onNoteEdit);
    on<NotesOverviewNoteUpdate>(_onNoteUpdate);
    on<NotesOverviewNoteDelete>(_onNoteDelete);
    on<NotesOverviewNoteEditCancel>(_onNoteEditCancel);
    on<NotesOverviewDatePick>(_onDatePick);
    on<NotesOverviewDatePickEnd>(_onDatePickEnd);
    on<NotesOverviewSearchStart>(_onSearchStart);
    on<NotesOverviewSearchEnd>(_onSearchEnd);
    on<NotesOverviewSearchQuery>(_onSearchQuery);
    on<NotesOverviewNoteRestore>(_onNoteRestore);
    on<NotesOverviewExport>(_onExport);
    on<NotesOverviewImport>(_onImport);
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
  }

  Future<void> _onTextChange(
    NotesOverviewInputFieldChanged event,
    Emitter<NotesOverviewState> emit,
  ) async {
    emit(state.copyWith(inputField: event.text));
  }

  Future<void> _onNoteAdd(
    NotesOverviewNoteAdd event,
    Emitter<NotesOverviewState> emit,
  ) async {
    final note = Note.fromBody(state.inputField);
    await _notesRepository.insertNote(note).run();
  }

  Future<void> _onNoteDelete(
    NotesOverviewNoteDelete event,
    Emitter<NotesOverviewState> emit,
  ) async {
    if (event.id == state.editingNoteId) {
      emit(
        state.copyWith(
          editingNoteId: 0,
          inputField: '',
          cleanInputField: true,
        ),
      );
      emit(
        state.copyWith(
          cleanInputField: false,
        ),
      );
    }
    emit(
      state.copyWith(
        lastDeletedNote: state.notes.firstWhere(
          (el) => el.id == event.id,
        ),
      ),
    );
    await _notesRepository.deleteNote(event.id).run();
  }

  Future<void> _onNoteRestore(
    NotesOverviewNoteRestore event,
    Emitter<NotesOverviewState> emit,
  ) async {
    await _notesRepository
        .insertNote(
          state.lastDeletedNote.copyWith(
            id: DateTime.now().millisecondsSinceEpoch,
          ),
        )
        .run();
  }

  Future<void> _onNoteUpdate(
    NotesOverviewNoteUpdate event,
    Emitter<NotesOverviewState> emit,
  ) async {
    final note = state.notes.firstWhere(
      (note) => note.id == state.editingNoteId,
    );
    if (note.body != state.inputField) {
      await _notesRepository
          .updateNote(
            note.copyWith(
              body: state.inputField,
            ),
          )
          .run();
    }
    emit(
      state.copyWith(
        editingNoteId: 0,
        inputField: '',
      ),
    );
  }

  Future<void> _onNoteEdit(
    NotesOverviewNoteEdit event,
    Emitter<NotesOverviewState> emit,
  ) async {
    emit(
      state.copyWith(
        editingNoteId: event.note.id,
        inputField: event.note.body,
      ),
    );
  }

  Future<void> _onNoteEditCancel(
    NotesOverviewNoteEditCancel event,
    Emitter<NotesOverviewState> emit,
  ) async {
    emit(
      state.copyWith(
        editingNoteId: 0,
        inputField: '',
      ),
    );
  }

  Future<void> _onDatePick(
    NotesOverviewDatePick event,
    Emitter<NotesOverviewState> emit,
  ) async {
    final pickedDate = event.datePicked;
    final filteredNotes = state.notes.retainWhere((note) =>
        DateTime.fromMillisecondsSinceEpoch(note.dateCreated)
            .eqvYearMonthDay(pickedDate));
    emit(
      state.copyWith(
        filteredNotes: filteredNotes,
        datePicked: pickedDate.millisecondsSinceEpoch,
      ),
    );
  }

  Future<void> _onDatePickEnd(
    NotesOverviewDatePickEnd event,
    Emitter<NotesOverviewState> emit,
  ) async {
    emit(
      state.copyWith(
        filteredNotes: const IList<Note>.empty(),
        datePicked: 0,
      ),
    );
  }

  Future<void> _onSearchStart(
    NotesOverviewSearchStart event,
    Emitter<NotesOverviewState> emit,
  ) async {
    emit(
      state.copyWith(
        searchStatus: true,
      ),
    );
  }

  Future<void> _onSearchEnd(
    NotesOverviewSearchEnd event,
    Emitter<NotesOverviewState> emit,
  ) async {
    emit(
      state.copyWith(
        searchStatus: false,
        filteredNotes: const IList.empty(),
      ),
    );
  }

  Future<void> _onSearchQuery(
    NotesOverviewSearchQuery event,
    Emitter<NotesOverviewState> emit,
  ) async {
    final query = event.query;
    late IList<Note> filteredNotes;
    if (state.datePicked != 0) {
      final datePicked = DateTime.fromMillisecondsSinceEpoch(state.datePicked);

      filteredNotes = state.notes.retainWhere((note) {
        final sameDate = DateTime.fromMillisecondsSinceEpoch(note.dateCreated)
            .eqvYearMonthDay(datePicked);
        final containsQuery = note.body.toLowerCase().contains(
              query.toLowerCase(),
            );
        return sameDate && containsQuery;
      });
    } else {
      filteredNotes = state.notes.retainWhere(
        (note) => note.body.toLowerCase().contains(
              query.toLowerCase(),
            ),
      );
    }
    emit(
      state.copyWith(
        filteredNotes: filteredNotes,
      ),
    );
  }

  Future<void> _onExport(
    NotesOverviewExport event,
    Emitter<NotesOverviewState> emit,
  ) async {
    final now = DateTime.now();
    final timeStamp = '${now.year}-${now.month}-${now.day}';
    final fileName = 'notes_export_$timeStamp.csv';
    String? filePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Select a folder to export csv with notes',
      fileName: fileName,
      bytes: Uint8List(
          0), //https://github.com/miguelpruivo/flutter_file_picker/issues/1523
    );
    if (filePath == null) return;

    await _notesRepository.exportNotes(filePath).run();
    emit(state.copyWith(message: 'Notes were exported to $filePath'));
  }

  Future<void> _onImport(
    NotesOverviewImport event,
    Emitter<NotesOverviewState> emit,
  ) async {
    final filePaths = await FilePicker.platform.pickFiles(
      dialogTitle: 'Select a folder to export csv with notes',
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (filePaths == null) return;

    final filePath = filePaths.paths[0];
    if (filePath == null) {
      emit(state.copyWith(message: 'File path is empty'));
      return;
    }

    await _notesRepository.importNotes(filePath).run();
    emit(state.copyWith(message: 'Notes were imported'));
  }
}
