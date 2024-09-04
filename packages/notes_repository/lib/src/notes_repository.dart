import 'dart:typed_data';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fpdart/fpdart.dart';
import 'package:note_sqflite_api/note_sqflite_api.dart';

/// {@template notes_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class NotesRepository {
  /// {@macro notes_repository}
  const NotesRepository({required NoteSqfliteApi localApi})
      : _localApi = localApi;

  final NoteSqfliteApi _localApi;

  Stream<IList<Note>> getNotesStream() {
    return _localApi.getNotesStream();
  }

  Task<List<Map<String, dynamic>>> getNote(
    int id,
  ) =>
      _localApi.getNote(id);

  Task<void> insertNote(
    Note note,
  ) =>
      _localApi.insertNote(
        note,
      );

  Task<void> updateNote(
    Note note,
  ) =>
      _localApi.updateNote(
        note,
      );

  Task<void> deleteNote(
    int noteId,
  ) =>
      _localApi.deleteNote(
        noteId,
      );
  Task<void> exportNotes(
    String filePath,
  ) =>
      _localApi.exportNotes(
        filePath,
      );

  Task<Uint8List> getNotesAsString() =>
      _localApi.getNotesAsString();

  Task<void> importNotes(
    String filePath,
  ) =>
      _localApi.importNotes(
        filePath,
      );
}
