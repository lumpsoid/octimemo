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
    return _localApi.getNotesStream(_localApi);
  }

  Task<List<Map<String, dynamic>>> getNote(
    int id,
  ) =>
      _localApi.getNote(_localApi, id);

  Task<int> insertNote(
    Note note,
  ) =>
      _localApi.insertNote(
        note,
      );

  Task<int> updateNote(
    Note note,
  ) =>
      _localApi.updateNote(
        note,
      );

  Task<int> deleteNote(
    int noteId,
  ) =>
      _localApi.deleteNote(
        noteId,
      );
}
