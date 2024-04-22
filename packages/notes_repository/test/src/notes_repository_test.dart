// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note_sqflite_api/note_sqflite_api.dart';
import 'package:notes_repository/notes_repository.dart';

void main() {
  group('NotesRepository', () {
    test('can be instantiated', () async {
      final localApi = NoteSqfliteApi();
      expect(NotesRepository(localApi: localApi), isNotNull);
    });
  });
}
