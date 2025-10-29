import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../../data/datasources/database_helper.dart';
import '../../domain/entities/user.dart';

class AuthController extends GetxController {
  final RxBool isLoggedIn = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedInPref = prefs.getBool('is_logged_in') ?? false;
    final userId = prefs.getInt('user_id');
    
    if (isLoggedInPref && userId != null) {
      await loadUser(userId);
      isLoggedIn.value = true;
    }
  }

  Future<void> loadUser(int userId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    
    if (maps.isNotEmpty) {
      currentUser.value = User.fromMap(maps.first);
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> login(String username, String password) async {
    try {
      final db = await _dbHelper.database;
      final passwordHash = _hashPassword(password);
      
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'username = ? AND password_hash = ?',
        whereArgs: [username, passwordHash],
      );
      
      if (maps.isNotEmpty) {
        final user = User.fromMap(maps.first);
        currentUser.value = user;
        isLoggedIn.value = true;
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_logged_in', true);
        await prefs.setInt('user_id', user.id!);
        
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String username, String password) async {
    try {
      final db = await _dbHelper.database;
      final passwordHash = _hashPassword(password);
      
      // Check if user already exists
      final existing = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
      );
      
      if (existing.isNotEmpty) {
        return false; // User already exists
      }
      
      final user = User(
        username: username,
        passwordHash: passwordHash,
      );
      
      final id = await db.insert('users', user.toMap());
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
      
      final db = await _dbHelper.database;
      final oldPasswordHash = _hashPassword(oldPassword);
      
      // Verify old password
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'id = ? AND password_hash = ?',
        whereArgs: [currentUser.value!.id, oldPasswordHash],
      );
      
      if (maps.isEmpty) {
        return false; // Old password incorrect
      }
      
      // Update with new password
      final newPasswordHash = _hashPassword(newPassword);
      await db.update(
        'users',
        {'password_hash': newPasswordHash, 'updated_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [currentUser.value!.id],
      );
      
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    isLoggedIn.value = false;
    currentUser.value = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    await prefs.remove('user_id');
    
    Get.offAllNamed('/login');
  }

  Future<bool> hasAnyUser() async {
    final db = await _dbHelper.database;
    final result = await db.query('users', limit: 1);
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
