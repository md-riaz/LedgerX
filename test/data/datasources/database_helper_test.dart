import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledgerx/data/datasources/ledger_database.dart';

void main() {
  group('LedgerDatabase', () {
    late LedgerDatabase database;

    setUp(() {
      database = LedgerDatabase.forTesting(NativeDatabase.memory());
    });

    tearDown(() async {
      await database.close();
    });

    test('creates tables and persists customers', () async {
      final id = await database.into(database.dbCustomers).insert(
            DbCustomersCompanion.insert(name: 'Alice'),
          );

      final row = await (database.select(database.dbCustomers)
            ..where((tbl) => tbl.id.equals(id)))
          .getSingle();

      expect(row.name, 'Alice');
    });

    test('supports inserting ledger entries', () async {
      final customerId = await database.into(database.dbCustomers).insert(
            DbCustomersCompanion.insert(name: 'Bob'),
          );

      final entryId = await database.into(database.dbEntries).insert(
            DbEntriesCompanion.insert(
              customerId: customerId,
              type: 'credit',
              amount: 120.0,
              date: Value(DateTime(2024, 1, 1)),
            ),
          );

      final entry = await (database.select(database.dbEntries)
            ..where((tbl) => tbl.id.equals(entryId)))
          .getSingle();

      expect(entry.customerId, customerId);
      expect(entry.amount, 120.0);
      expect(entry.type, 'credit');
    });
  });
}
