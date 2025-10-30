import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:ledgerx/utils/io_stub.dart' if (dart.library.io) 'dart:io'
    as io;
import 'package:ledgerx/utils/platform_utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Encryption key (in production, this should be securely managed)
  // Must remain 32 bytes so AES-256 can derive a valid key
  static const String _encryptionKey = 'ledgerx_secure_key_32_chars!!!!!';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ledgerx.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await _getDatabasePath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<String> _getDatabasePath() async {
    if (PlatformUtils.isWeb) {
      return 'ledgerx_web_db';
    }

    if (PlatformUtils.isDesktop) {
      final appDir = await getApplicationDocumentsDirectory();
      final dbDir = io.Directory(join(appDir.path, 'LedgerX', 'data'));
      if (!await dbDir.exists()) {
        await dbDir.create(recursive: true);
      }
      return dbDir.path;
    }

    return await getDatabasesPath();
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    // Users table for authentication
    await db.execute('''
      CREATE TABLE users (
        id $idType,
        username $textType UNIQUE,
        password_hash $textType,
        created_at $textType,
        updated_at $textType
      )
    ''');

    // Customers table (email removed for local store use)
    await db.execute('''
      CREATE TABLE customers (
        id $idType,
        name $textType,
        phone TEXT,
        address TEXT,
        notes TEXT,
        created_at $textType,
        updated_at $textType
      )
    ''');

    // Entries table
    await db.execute('''
      CREATE TABLE entries (
        id $idType,
        customer_id $integerType,
        type $textType,
        amount $realType,
        description TEXT,
        date $textType,
        tags TEXT,
        created_at $textType,
        updated_at $textType,
        FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE
      )
    ''');

    // Tags table
    await db.execute('''
      CREATE TABLE tags (
        id $idType,
        name $textType UNIQUE,
        color TEXT,
        created_at $textType
      )
    ''');

    // Reminders table
    await db.execute('''
      CREATE TABLE reminders (
        id $idType,
        customer_id $integerType,
        title $textType,
        description TEXT,
        due_date $textType,
        is_completed $integerType DEFAULT 0,
        created_at $textType,
        FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE
      )
    ''');

    // Audit log table
    await db.execute('''
      CREATE TABLE audit_logs (
        id $idType,
        action $textType,
        entity_type $textType,
        entity_id INTEGER,
        details TEXT,
        created_at $textType
      )
    ''');

    // Create indexes for better performance
    await db.execute(
        'CREATE INDEX idx_entries_customer_id ON entries(customer_id)');
    await db.execute('CREATE INDEX idx_entries_date ON entries(date)');
    await db.execute(
        'CREATE INDEX idx_reminders_customer_id ON reminders(customer_id)');
    await db.execute(
        'CREATE INDEX idx_audit_logs_entity ON audit_logs(entity_type, entity_id)');
  }

  // Encryption helpers
  String encryptData(String plainText) {
    final key = encrypt.Key.fromUtf8(_encryptionKey);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  String decryptData(String encryptedText) {
    try {
      final key = encrypt.Key.fromUtf8(_encryptionKey);
      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
      return decrypted;
    } catch (e) {
      return encryptedText; // Return as is if decryption fails
    }
  }

  // Hash sensitive data
  String hashData(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
