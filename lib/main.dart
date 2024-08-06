import 'package:flutter/material.dart';
import 'package:note_sqflite_api/note_sqflite_api.dart';
import 'package:octimemo/bootstrap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final localApi = NoteSqfliteApi()..initializeDb();

  bootstrap(localApi: localApi);
}
