// ignore_for_file: prefer_const_constructors
import 'package:local_sqflite_api/local_sqflite_api.dart';
import 'package:test/test.dart';

void main() {
  group('LocalSqfliteApi', () {
    test('can be instantiated', () async {
      expect(LocalSqfliteApi(), isNotNull);
    });
  });
}
