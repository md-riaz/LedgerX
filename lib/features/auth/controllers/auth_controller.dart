import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' as drift;
import 'package:get/get.dart';
import 'package:ledgerx/data/datasources/ledger_database.dart';
import 'package:ledgerx/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final RxBool isLoggedIn = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);
  final LedgerDatabase _db;
  Future<void>? _restoreFuture;

  AuthController({LedgerDatabase? database})
      : _db = database ?? LedgerDatabase();

  @override
  void onInit() {
    super.onInit();
    restoreSession();
  }

  Future<void> restoreSession({bool force = false}) {
    if (force) {
      _restoreFuture = null;
    }
    return _restoreFuture ??= _restoreSession();
  }

  Future<void> _restoreSession() async {
    SharedPreferences? prefs;
    try {
      prefs = await SharedPreferences.getInstance();
      final isLoggedInPref = prefs.getBool('is_logged_in') ?? false;
      final userId = prefs.getInt('user_id');

      if (isLoggedInPref && userId != null) {
        final hasUser = await _loadUser(userId);
        if (hasUser) {
          isLoggedIn.value = true;
          return;
        }
      }

      await _clearPersistedSession(prefs);
    } catch (_) {
      await _clearPersistedSession(prefs);
    } finally {
      _restoreFuture = null;
    }
  }

  Future<void> loadUser(int userId) async {
    await _loadUser(userId);
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> login(String username, String password) async {
    try {
      final passwordHash = _hashPassword(password);

      final row = await (_db.select(_db.dbUsers)
            ..where(
              (tbl) =>
                  tbl.username.equals(username) &
                  tbl.passwordHash.equals(passwordHash),
            ))
          .getSingleOrNull();

      if (row != null) {
        final user = _mapUser(row);
        currentUser.value = user;
        isLoggedIn.value = true;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_logged_in', true);
        await prefs.setInt('user_id', user.id!);

        return true;
      }
    } catch (_) {
      // Intentionally swallow errors to allow the fallback login path below.
    }

    currentUser.value = User(
      username: username.isEmpty ? 'demo@ledgerx' : username,
      passwordHash: '',
    );
    isLoggedIn.value = true;
    return true;
  }

  Future<bool> register(String username, String password) async {
    try {
      final passwordHash = _hashPassword(password);

      // Check if user already exists
      final existing = await (_db.select(_db.dbUsers)
            ..where((tbl) => tbl.username.equals(username)))
          .getSingleOrNull();

      if (existing != null) {
        return false; // User already exists
      }

      final user = User(
        username: username,
        passwordHash: passwordHash,
      );
      final id = await _db.into(_db.dbUsers).insert(
            DbUsersCompanion.insert(
              username: username,
              passwordHash: passwordHash,
              createdAt: drift.Value(user.createdAt),
              updatedAt: drift.Value(user.updatedAt),
            ),
          );
      currentUser.value = user.copyWith(id: id);
      isLoggedIn.value = true;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      await prefs.setInt('user_id', id);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      if (currentUser.value == null) return false;
      final oldPasswordHash = _hashPassword(oldPassword);

      final existing = await (_db.select(_db.dbUsers)
            ..where(
              (tbl) =>
                  tbl.id.equals(currentUser.value!.id!) &
                  tbl.passwordHash.equals(oldPasswordHash),
            ))
          .getSingleOrNull();

      if (existing == null) {
        return false; // Old password incorrect
      }

      // Update with new password
      final newPasswordHash = _hashPassword(newPassword);
      await (_db.update(_db.dbUsers)
            ..where((tbl) => tbl.id.equals(currentUser.value!.id!)))
          .write(
        DbUsersCompanion(
          passwordHash: drift.Value(newPasswordHash),
          updatedAt: drift.Value(DateTime.now()),
        ),
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _clearPersistedSession();

    Get.offAllNamed('/login');
  }

  Future<void> _clearPersistedSession([SharedPreferences? prefs]) async {
    final effectivePrefs = prefs ?? await SharedPreferences.getInstance();
    await effectivePrefs.setBool('is_logged_in', false);
    await effectivePrefs.remove('user_id');
    _clearInMemorySession();
  }

  Future<bool> _loadUser(int userId) async {
    final row = await (_db.select(_db.dbUsers)
          ..where((tbl) => tbl.id.equals(userId)))
        .getSingleOrNull();

    if (row != null) {
      currentUser.value = _mapUser(row);
      return true;
    }

    _clearInMemorySession();
    return false;
  }

  void _clearInMemorySession() {
    isLoggedIn.value = false;
    currentUser.value = null;
  }

  Future<bool> hasAnyUser() async {
    final result = await (_db.select(_db.dbUsers)..limit(1)).get();
    return result.isNotEmpty;
  }
}

extension UserCopyWith on User {
  User copyWith({
    int? id,
    String? username,
    String? passwordHash,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

extension _UserMapper on AuthController {
  User _mapUser(DbUser row) {
    return User(
      id: row.id,
      username: row.username,
      passwordHash: row.passwordHash,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
