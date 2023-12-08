import 'package:flutter/material.dart';
import 'db_helper.dart';

import 'note.dart' show Note;
import 'page.dart' show NotePage, itemsPerPage;

class NoteManager extends ChangeNotifier {
  final DbHelper _dbHelper = DbHelper();
  final Map<int, NotePage> _pages = {};
  final Set<int> _pagesBeingFetched = {};
  int? itemCount;
  static const maxCacheDistance = 100;

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Note getByIndex(int index) {
    int startingIndex = (index ~/ itemsPerPage) * itemsPerPage;

    if (_pages.containsKey(startingIndex)) {
      Note item = _pages[startingIndex]!.items[index - startingIndex];
      return item;
    }

    _fetchPage(startingIndex);

    return Note.loading();
  }

  Future<void> _fetchPage(int startingIndex) async {
    if (_pagesBeingFetched.contains(startingIndex)) {
      return;
    }

    _pagesBeingFetched.add(startingIndex);
    final NotePage page = await _dbHelper.fetchNotes(startingIndex);
    _pagesBeingFetched.remove(startingIndex);

    if (!page.hasNext) {
      itemCount = startingIndex + page.items.length;
    }

    _pages[startingIndex] = page;
    _pruneCache(startingIndex);

    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void _pruneCache(int currentStartingIndex) {
    final keysToRemove = <int>{};
    for (final key in _pages.keys) {
      if ((key - currentStartingIndex).abs() > maxCacheDistance) {
        keysToRemove.add(key);
      }
    }
    for (final key in keysToRemove) {
      _pages.remove(key);
    }
  }

  Future<void> addNote(String body) async {
    Note note = Note(body: body);
    _dbHelper.insertNote(note);

    if (itemCount != null) {
      int index = itemCount! + 1;
      int startingIndex = (index ~/ itemsPerPage) * itemsPerPage;

      if (_pages.containsKey(startingIndex)) {
        _pages[startingIndex]!.addNote(note);
      } else {
        NotePage page = NotePage(
            items: [note], startingIndex: startingIndex, hasNext: false);
        _pages[startingIndex] = page;
        _pruneCache(startingIndex);
      }
      itemCount = index;
    } else {
      throw StateError('itemCount is null');
    }
    notifyListeners();
  }

  Future<void> deleteNote(int index) async {
    int startingIndex = (index ~/ itemsPerPage) * itemsPerPage;
    Note note = _pages[startingIndex]!.items.removeAt(index - startingIndex);
    _dbHelper.deleteNote(note.id);
    if (_pages[startingIndex]!.items.isEmpty) {
      _pages.remove(startingIndex);
    }
    itemCount = itemCount! - 1;
    notifyListeners();
  }

  Future<void> editNote(int index, String body) async {
    int startingIndex = (index ~/ itemsPerPage) * itemsPerPage;
    Note note = _pages[startingIndex]!.items[index - startingIndex];
    note.update(body: body);
    notifyListeners();
  }
}
