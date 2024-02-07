import 'dart:collection';

import 'package:flutter/material.dart';
import 'db_helper.dart';

import 'note.dart' show Note;
import 'page.dart' show NotePage, itemsPerPage;

// TODO move all note data transformation for db to db_helper
class NoteManager extends ChangeNotifier {
  final DbHelper _dbHelper;
  final LinkedList<Note> _notes = LinkedList<Note>();
  final Set<int> _notesBeingFetched = {};
  int? _itemCount;
  int? editingIndex;
  bool isSnackbarVisible = false;
  static const maxCacheDistance = 100;

  bool _isDisposed = false;

  get itemCount => _itemCount;

  NoteManager(this._dbHelper);

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Note getByIndex(int index) {
    Note? note = _notes.elementAtOrNull(index);
    if (note != null && !note.isNull) {
      return note;
    }

    int startingIndex = (index ~/ itemsPerPage) * itemsPerPage;
    if (note != null && note.isNull) {
      _fetchPage(startingIndex, update: true);
    }
    _fetchPage(startingIndex, update: false);

    return Note.loading();
  }

  Future<void> _fetchPage(int startingIndex, {required bool update}) async {
    if (_notesBeingFetched.contains(startingIndex)) {
      return;
    }

    _notesBeingFetched.add(startingIndex);
    final NotePage page = await _dbHelper.fetchNotes(startingIndex);
    _notesBeingFetched.remove(startingIndex);

    if (!page.hasNext) {
      _itemCount = startingIndex + page.items.length;
    }

    if (update) {
      Note note = _notes.elementAt(startingIndex);
      for (var i = 0; i < itemsPerPage; i++) {
        note.reFetch(page.items[i]);
        if (note.next != null) {
          note = note.next!;
        }
      }
    } else {
      _notes.addAll(page.items);
    }
    _pruneCache(startingIndex);

    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void _pruneCache(int currentStartingIndex) {
    /// Distanse of [maxCacheDistance] is greater than length of [_notes].
    /// So there is nothing to clear.
    int endIndexData = currentStartingIndex + maxCacheDistance;
    if (endIndexData < _notes.length) {
      Note noteFromEnd = _notes.last;
      for (int i = endIndexData + 1; i < _notes.length; i++) {
        if (!noteFromEnd.isNull) {
          noteFromEnd.prune();
        }
        noteFromEnd = noteFromEnd.previous!;
      }
    }

    int startIndexData = currentStartingIndex - maxCacheDistance;
    if (startIndexData > 0) {
      Note noteFromStart = _notes.first;
      for (int i = 0; i < startIndexData; i++) {
        if (!noteFromStart.isNull) {
          noteFromStart.prune();
        }
        noteFromStart = noteFromStart.next!;
      }
    }
  }

  Future<void> addNote(String body) async {
    Note note = Note(body: body);
    // _notes.addFirst(note);

    // if its null, than ourl list is not at the end
    // than we can simple add it into the db
    // and fetch will get it later
    if (_itemCount == null) {
      return;
    }

    _notes.add(note);
    _itemCount = _itemCount! + 1;
    notifyListeners();
    _dbHelper.insertNote(note);
  }

  Future<void> deleteNote(Note note) async {
    if (note.isNull) {
      throw ArgumentError('note object has null parameters');
    }

    note.unlink();
    _dbHelper.deleteNote(note.id!);

    if (_itemCount != null) {
      _itemCount = _itemCount! - 1;
      notifyListeners();
    }
  }

  Future<void> editNote(Note note, String bodyNew) async {
    // int startingIndex = (index ~/ itemsPerPage) * itemsPerPage;
    // Note note = _pages[startingIndex]!.items[index - startingIndex];
    note.update(body: bodyNew);
    _dbHelper.updateNote(note);
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
