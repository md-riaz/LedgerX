import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ledgerx/data/datasources/ledger_database.dart';
import 'package:ledgerx/features/auth/controllers/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.testMode = true;
  });

  group('AuthController operations', () {
    late LedgerDatabase database;
    late AuthController controller;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      database = LedgerDatabase.forTesting(NativeDatabase.memory());
      controller = AuthController(database: database);
      controller.onInit();
      await controller.restoreSession(force: true);
    });

    tearDown(() async {
      await database.close();
      Get.deleteAll(force: true);
      Get.reset();
    });

    test('registers a new user and persists the session', () async {
      final success = await controller.register('alice', 'password123');

      expect(success, isTrue);
      expect(controller.isLoggedIn.value, isTrue);

      final row = await (database.select(database.dbUsers)
            ..where((tbl) => tbl.username.equals('alice')))
          .getSingle();

      expect(row.username, 'alice');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('is_logged_in'), isTrue);
      expect(prefs.getInt('user_id'), row.id);
    });

    test('logs in with stored credentials', () async {
      await controller.register('bob', 's3cret');
      await controller.logout();

      final success = await controller.login('bob', 's3cret');

      expect(success, isTrue);
      expect(controller.isLoggedIn.value, isTrue);
      expect(controller.currentUser.value?.username, 'bob');
    });

    test('changes password updates stored hash', () async {
      await controller.register('carol', 'temp-pass');

      final oldRow = await (database.select(database.dbUsers)
            ..where((tbl) => tbl.username.equals('carol')))
          .getSingle();
      final oldHash = oldRow.passwordHash;

      final success = await controller.changePassword('temp-pass', 'n3w-pass');

      expect(success, isTrue);

      final newRow = await (database.select(database.dbUsers)
            ..where((tbl) => tbl.username.equals('carol')))
          .getSingle();

      final expectedNewHash = sha256.convert(utf8.encode('n3w-pass')).toString();

      expect(newRow.passwordHash, expectedNewHash);
      expect(newRow.passwordHash, isNot(equals(oldHash)));
    });

    test('restores persisted session for returning user', () async {
      await controller.register('dave', 'pass123');

      final restored = AuthController(database: database);
      restored.onInit();
      await restored.restoreSession();

      expect(restored.isLoggedIn.value, isTrue);
      expect(restored.currentUser.value?.username, 'dave');
    });
  });
}
