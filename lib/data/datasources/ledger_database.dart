// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift/web.dart';
import 'package:flutter/foundation.dart';
import 'package:ledgerx/utils/io_stub.dart' if (dart.library.io) 'dart:io'
    as io;
import 'package:ledgerx/utils/platform_utils.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'ledger_database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    if (kIsWeb) {
      final storage = DriftWebStorage.indexedDb('ledgerx_db');
      return WebDatabase.withStorage(storage);
    }

    final docDir = await getApplicationDocumentsDirectory();
    String dbPath;

    if (PlatformUtils.isDesktop) {
      final dataDir = io.Directory(p.join(docDir.path, 'LedgerX', 'data'));
      if (!await dataDir.exists()) {
        await dataDir.create(recursive: true);
      }
      dbPath = p.join(dataDir.path, 'ledgerx.db');
    } else {
      dbPath = p.join(docDir.path, 'ledgerx.db');
    }

    final file = io.File(dbPath);
    // Cast to dynamic so compilation succeeds when using the web stub implementation.
    return NativeDatabase.createInBackground(file as dynamic);
  });
}

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

  static final LedgerDatabase instance = LedgerDatabase._(_openConnection());

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
}
