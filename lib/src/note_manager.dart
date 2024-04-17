import 'package:flutter/material.dart';
import 'package:local_sqflite_api/local_sqflite_api.dart';

class NoteManager extends ChangeNotifier {
  final LocalSqfliteApi _localApi;
  final List<Note> _notes = <Note>[];
  int? editingIndex;
  bool isSnackbarVisible = false;
  static const maxCacheDistance = 100;

  bool _isDisposed = false;

  int get notesCount => _notes.length;

  NoteManager(this._localApi);

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Note getByIndex(int index) {
    return _notes[index];
  }

  Future<void> addNote(String body) async {
    Note note = createNewNote(body).run();

    _notes.add(note);
    notifyListeners();
    insertNoteInDb(_localApi, note).run();
  }

  Future<void> deleteNote(Note note) async {
    _notes.removeWhere((element) => element.id == note.id);
    deleteNoteFromDb(_localApi, note.id).run();
    notifyListeners();
  }

  Future<void> editNote(
    Note note,
    String bodyNew,
  ) async {
    final noteUpdated = updateNote(note, bodyNew);
    updateNoteInDb(_localApi, noteUpdated).run();
    notifyListeners();
  }

  bool isEditing(int index) => editingIndex == index;

  void startEditing(int index) {
    editingIndex = index;
    notifyListeners();
  }

  void stopEditing() {
    editingIndex = null;
    notifyListeners();
  }
}
