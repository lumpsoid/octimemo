import 'package:flutter/material.dart';
import 'package:note_sqflite_api/note_sqflite_api.dart';
import 'package:memocti/bootstrap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final localApi = NoteSqfliteApi()..initializeDb();

  bootstrap(localApi: localApi);
}
