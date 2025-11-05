// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:ledgerx/utils/io_stub.dart' if (dart.library.io) 'dart:io'
    as io;
import 'package:ledgerx/utils/platform_utils.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'connection/connection.dart';
import 'connection/web_backup_stub.dart'
    if (dart.library.js_interop) 'connection/connection_web.dart' as web_db;

part 'ledger_database.g.dart';

QueryExecutor _openConnection() => openConnection();

class DbUsers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().unique()();
  TextColumn get passwordHash => text().named('password_hash')();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').withDefault(currentDateAndTime)();
}

class DbCustomers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').withDefault(currentDateAndTime)();
}

class DbEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get customerId => integer()
      .named('customer_id')
      .references(DbCustomers, #id, onDelete: KeyAction.cascade)();
  TextColumn get type => text()();
  RealColumn get amount => real()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  TextColumn get tags => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').withDefault(currentDateAndTime)();
}

class DbTags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get color => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
}

class DbReminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get customerId => integer()
      .named('customer_id')
      .references(DbCustomers, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get dueDate => dateTime().named('due_date')();
  BoolColumn get isCompleted =>
      boolean().named('is_completed').withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
}

class DbAuditLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get action => text()();
  TextColumn get entityType => text().named('entity_type')();
  IntColumn get entityId => integer().named('entity_id').nullable()();
  TextColumn get details => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
}

@DriftDatabase(
  tables: [
    DbUsers,
    DbCustomers,
    DbEntries,
    DbTags,
    DbReminders,
    DbAuditLogs,
  ],
)
class LedgerDatabase extends _$LedgerDatabase {
  LedgerDatabase._(super.executor);

  factory LedgerDatabase() => instance;

  factory LedgerDatabase.forTesting(QueryExecutor executor) =>
      LedgerDatabase._(executor);

  static LedgerDatabase instance = LedgerDatabase._(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<void> warmUp() async {
    await customSelect('SELECT 1').getSingle();
  }

  Future<String?> resolvedDatabasePath() async {
    if (kIsWeb) {
      return 'IndexedDB: ledgerx_db';
    }

    final docDir = await getApplicationDocumentsDirectory();

    if (PlatformUtils.isDesktop) {
      final dataDir = io.Directory(p.join(docDir.path, 'LedgerX', 'data'));
      if (!await dataDir.exists()) {
        await dataDir.create(recursive: true);
      }
      return p.join(dataDir.path, 'ledgerx.db');
    }

    return p.join(docDir.path, 'ledgerx.db');
  }

  Future<io.File?> databaseFilePath() async {
    if (kIsWeb) {
      return null;
    }

    final resolvedPath = await resolvedDatabasePath();
    if (resolvedPath == null) {
      return null;
    }

    final directory = io.Directory(p.dirname(resolvedPath));
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return io.File(resolvedPath);
  }

  Future<Uint8List?> exportDatabaseBytes() async {
    if (kIsWeb) {
      return web_db.exportLedgerDatabaseBytes();
    }

    final file = await databaseFilePath();
    if (file == null || !await file.exists()) {
      return null;
    }

    final bytes = await file.readAsBytes();
    return Uint8List.fromList(bytes);
  }

  Future<void> importDatabaseFromBytes(Uint8List bytes) async {
    if (kIsWeb) {
      await web_db.importLedgerDatabaseBytes(bytes);
      return;
    }

    final file = await databaseFilePath();
    if (file == null) {
      throw StateError('No database file available for import.');
    }

    await file.writeAsBytes(bytes, flush: true);
  }

  Future<LedgerDatabase> reopen() async {
    try {
      await close();
    } catch (_) {
      // Ignored: closing an already-closed connection should not block reopen.
    }

    if (kIsWeb) {
      final hasSeed = web_db.consumePendingLedgerSeed();
      if (!hasSeed) {
        web_db.prepareLedgerDatabaseOpening();
      }
    }

    final reopened = LedgerDatabase._(_openConnection());
    instance = reopened;
    return reopened;
  }
}
