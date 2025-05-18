// ignore_for_file: use_setters_to_change_properties

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:notes_repository/notes_repository.dart';
import 'package:octimemo/notes_overview/notes_overview.dart';
import 'package:octimemo/service_locator/service_locator.dart';

sealed class NotesOverviewEffect extends Equatable {
  const NotesOverviewEffect();

  @override
  List<Object> get props => [];
}

class ClearGlobalInputEffect extends NotesOverviewEffect {
  const ClearGlobalInputEffect();
}

class NoteDeletedEffect extends NotesOverviewEffect {
  const NoteDeletedEffect();
}

class OpenMenuEffect extends NotesOverviewEffect {
  const OpenMenuEffect();
}

class FocusGlobalInputEffect extends NotesOverviewEffect {
  const FocusGlobalInputEffect();
}

class UnFocusGlobalInputEffect extends NotesOverviewEffect {
  const UnFocusGlobalInputEffect();
}

/// When user tries to add empty note
class EmptyGlobalInputEffect extends NotesOverviewEffect {
  const EmptyGlobalInputEffect();
}

class FillGlobalInputEffect extends NotesOverviewEffect {
  const FillGlobalInputEffect(this.text);
  final String text;

  @override
  List<Object> get props => [text];
}

class CopiedToClipboardEvent extends NotesOverviewEffect {
  const CopiedToClipboardEvent(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

class ShowMessageEvent extends NotesOverviewEffect {
  const ShowMessageEvent(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

class ErrorEvent extends NotesOverviewEffect {
  const ErrorEvent(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

class EditingState {
  const EditingState({
    required this.text,
    this.noteId,
  });

  const EditingState.empty()
      : noteId = null,
        text = '';
  final int? noteId;
  final String text;

  bool get isEditing => noteId != null;
  bool get isEmpty => noteId == null && text.isEmpty;

  EditingState clear() {
    return const EditingState.empty();
  }

  EditingState copyWith({
    String? text,
    int? noteId,
  }) {
    return EditingState(
      text: text ?? this.text,
      noteId: noteId ?? this.noteId,
    );
  }
}

enum NotesOverviewStatus { loading, loaded, error }

class NotesOverviewViewModel {
  NotesOverviewViewModel({
    NotesRepository? notesRepository,
  })  : _notesRepository = notesRepository ?? getIt<NotesRepository>(),
        _effect = StreamController<NotesOverviewEffect?>.broadcast();

  final NotesRepository _notesRepository;

  // State ValueNotifiers
  Note? _lastDeletedNote; // Not a ValueNotifier, just internal state
  late StreamSubscription<IList<Note>> _notesSubscription;

  // Core states
  final canPop = ValueNotifier<bool>(true);
  final status =
      ValueNotifier<NotesOverviewStatus>(NotesOverviewStatus.loading);
  final notes = ValueNotifier<IList<Note>>(const IList<Note>.empty());
  final editingState = ValueNotifier<EditingState>(const EditingState.empty());
  final selectedDate = ValueNotifier<DateTime?>(null);
  final searchQuery = ValueNotifier<String>('');
  final filters = FilterManager(const IMap.empty());

  final isActiveSearch = ValueNotifier(false);

  // Event notifier for side effects
  late final StreamController<NotesOverviewEffect?> _effect;

  Stream<NotesOverviewEffect?> get effect => _effect.stream;

  Future<void> init() async {
    await _loadNotes();
  }

  // Subscription
  Future<void> _loadNotes() async {
    status.value = NotesOverviewStatus.loading;
    try {
      _notesSubscription = _notesRepository.getNotesStream().listen(
        (notesList) {
          notes.value = notesList;
          status.value = NotesOverviewStatus.loaded;
        },
        // ignore: inference_failure_on_untyped_parameter
        onError: (error) {
          status.value = NotesOverviewStatus.error;
          _effect.add(ErrorEvent(error.toString()));
        },
      );
    } catch (e) {
      status.value = NotesOverviewStatus.error;
      _effect.add(ErrorEvent(e.toString()));
    }
  }

  Future<void> addEffect(NotesOverviewEffect e) async {
    _effect.add(e);
  }

  Future<void> clearEffect() async {
    _effect.add(null);
  }

  Future<void> changeQuery(String query) async {
    filters.setFilter(QueryFilter(query));
    canPop.value = false;
  }

  Future<void> clearQuery() async {
    filters.removeFilter(QueryFilter);
    maybeCanPop();
  }

  // UI Actions
  Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    _effect.add(const CopiedToClipboardEvent('Copied to clipboard'));
  }

  void changeInput(String text) {
    editingState.value = editingState.value.copyWith(text: text);
  }

  Note getNoteReversed(int index) {
    final reversedIndex = notes.value.length - 1 - index;
    return notes.value.get(reversedIndex);
  }

  Future<void> addNote() async {
    final note = Note.fromBody(editingState.value.text);
    await _notesRepository.insertNote(note).run();
    await clearInput();
  }

  Future<void> clearInput() async {
    editingState.value = editingState.value.clear();
    await addEffect(const ClearGlobalInputEffect());
  }

  Future<void> deleteNote(int id) async {
    if (id == editingState.value.noteId) {
      await clearInput();
    }

    final noteToDelete = notes.value.firstWhere((el) => el.id == id);
    _lastDeletedNote = noteToDelete;
    unawaited(addEffect(const NoteDeletedEffect()));

    await _notesRepository.deleteNote(id).run();
  }

  Future<void> restoreNote() async {
    if (_lastDeletedNote != null) {
      await _notesRepository
          .insertNote(
            _lastDeletedNote!.rotateId(),
          )
          .run();
    }
  }

  Future<void> updateNote() async {
    final bodyNew = editingState.value.text;
    final note = notes.value.firstWhere(
      (note) => note.id == editingState.value.noteId,
    );

    if (note.body != bodyNew) {
      await _notesRepository
          .updateNote(
            note.copyWith(body: bodyNew),
          )
          .run();
    }

    await clearInput();
  }

  void editNote(Note note) {
    editingState.value = editingState.value.copyWith(
      text: note.body,
      noteId: note.id,
    );
  }

  Future<void> startEditing(int noteId, String text) async {
    editingState.value = editingState.value.copyWith(
      noteId: noteId,
      text: text,
    );
    await addEffect(FillGlobalInputEffect(text));
    await addEffect(const FocusGlobalInputEffect());
  }

  void processNote() {
    final isEdition = editingState.value.noteId != null;

    if (editingState.value.text.isEmpty) {
      addEffect(const EmptyGlobalInputEffect());
      return;
    }

    if (isEdition) {
      updateNote();
      return;
    }

    addNote();
  }

  void cancelEdit() {
    editingState.value = editingState.value.clear();
  }

  void selectDate(DateTime pickedDate) {
    filters.setFilter(DateFilter(pickedDate));
    canPop.value = false;
  }

  void clearDate() {
    filters.removeFilter(DateFilter);
    maybeCanPop();
  }

  IList<Note> getFilteredNotes() {
    return filters.applyFilters(notes.value);
  }

  Future<void> exportNotes() async {
    final notesData = _notesRepository.getNotesAsString().run();

    final now = DateTime.now();
    final timeStamp = '${now.year}-${now.month}-${now.day}';
    final fileName = 'notes_export_$timeStamp.json';

    await FilePicker.platform.saveFile(
      dialogTitle: 'Select a folder to export csv with notes',
      fileName: fileName,
      initialDirectory: 'Download',
      bytes: await notesData,
    );
    _effect.add(const ShowMessageEvent('Notes were exported'));
  }

  Future<void> importNotes() async {
    final filePaths = await FilePicker.platform.pickFiles(
      dialogTitle: 'Select the notes backup to import',
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (filePaths == null) return;

    final filePath = filePaths.paths[0];
    if (filePath == null) {
      _effect.add(const ShowMessageEvent('File path is empty'));
      return;
    }

    try {
      await _notesRepository.importNotes(filePath).run();
      _effect.add(const ShowMessageEvent('Notes were imported'));
    } catch (e) {
      _effect.add(ErrorEvent(e.toString()));
    }
  }

  void maybeCanPop() {
    if (filters.value.isNotEmpty) {
      canPop.value = false;
    }

    canPop.value = true;
  }

  // ignore: avoid_positional_boolean_parameters
  void onPop(bool didPop, Object? result) {
    if (filters.value.isNotEmpty) {
      filters.clearFilters();
      canPop.value = true;
    }

    if (isActiveSearch.value) {
      toggleSearch();
    }
  }

  void toggleSearch() {
    // if search is active
    // we can't pop on back gesture
    canPop.value = isActiveSearch.value;

    isActiveSearch.value = !isActiveSearch.value;
  }

  void openMenu() {
    _effect.add(const OpenMenuEffect());
  }

  // Cleanup
  void dispose() {
    status.dispose();
    notes.dispose();
    editingState.dispose();
    searchQuery.dispose();
    selectedDate.dispose();
    isActiveSearch.dispose();
    _notesSubscription.cancel();
    _effect.close();
  }
}
