import 'package:drift/drift.dart';

import '../../domain/entities/entry.dart';
import '../../domain/repositories/entry_repository.dart';
import '../datasources/ledger_database.dart';
import 'audit_repository_impl.dart';

class EntryRepositoryImpl implements EntryRepository {
  EntryRepositoryImpl({
    LedgerDatabase? database,
    AuditRepositoryImpl? auditRepository,
  })  : _db = database ?? LedgerDatabase(),
        _auditRepo = auditRepository ??
            AuditRepositoryImpl(database: database ?? LedgerDatabase());

  final LedgerDatabase _db;
  final AuditRepositoryImpl _auditRepo;

  @override
  Future<List<Entry>> getAllEntries() async {
    final query = _db.select(_db.dbEntries)
      ..orderBy([
        (tbl) => OrderingTerm(expression: tbl.date, mode: OrderingMode.desc),
      ]);
    final rows = await query.get();
    return rows.map(_mapEntry).toList();
  }

  @override
  Future<List<Entry>> getEntriesByCustomer(int customerId) async {
    final query = _db.select(_db.dbEntries)
      ..where((tbl) => tbl.customerId.equals(customerId))
      ..orderBy([
        (tbl) => OrderingTerm(expression: tbl.date, mode: OrderingMode.desc),
      ]);
    final rows = await query.get();
    return rows.map(_mapEntry).toList();
  }

  @override
  Future<Entry?> getEntryById(int id) async {
    final row = await (_db.select(_db.dbEntries)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _mapEntry(row);
  }

  @override
  Future<int> createEntry(Entry entry) async {
    final id = await _db.into(_db.dbEntries).insert(
          DbEntriesCompanion.insert(
            customerId: entry.customerId,
            type: entry.type.name,
            amount: entry.amount,
            description: entry.description == null
                ? const Value.absent()
                : Value(entry.description!),
            date: Value(entry.date),
            tags: entry.tags.isEmpty
                ? const Value.absent()
                : Value(entry.tags.join(',')),
            createdAt: Value(entry.createdAt),
            updatedAt: Value(entry.updatedAt),
          ),
        );

    await _auditRepo.logAction(
      action: 'CREATE',
      entityType: 'Entry',
      entityId: id,
      details: 'Created ${entry.type.name} entry: ${entry.amount}',
    );

    return id;
  }

  @override
  Future<int> updateEntry(Entry entry) async {
    if (entry.id == null) {
      throw ArgumentError('Entry ID is required for update');
    }

    final result = await (_db.update(_db.dbEntries)
          ..where((tbl) => tbl.id.equals(entry.id!)))
        .write(
      DbEntriesCompanion(
        customerId: Value(entry.customerId),
        type: Value(entry.type.name),
        amount: Value(entry.amount),
        description: entry.description == null
            ? const Value.absent()
            : Value(entry.description!),
        date: Value(entry.date),
        tags: entry.tags.isEmpty
            ? const Value.absent()
            : Value(entry.tags.join(',')),
        updatedAt: Value(entry.updatedAt),
      ),
    );

    await _auditRepo.logAction(
      action: 'UPDATE',
      entityType: 'Entry',
      entityId: entry.id,
      details: 'Updated ${entry.type.name} entry: ${entry.amount}',
    );

    return result;
  }

  @override
  Future<int> deleteEntry(int id) async {
    final entry = await getEntryById(id);
    final result = await (_db.delete(_db.dbEntries)
          ..where((tbl) => tbl.id.equals(id)))
        .go();

    await _auditRepo.logAction(
      action: 'DELETE',
      entityType: 'Entry',
      entityId: id,
      details: 'Deleted ${entry?.type.name ?? 'Unknown'} entry',
    );

    return result;
  }

  @override
  Future<double> getBalance(int customerId) async {
    final rows = await (_db.select(_db.dbEntries)
          ..where((tbl) => tbl.customerId.equals(customerId)))
        .get();

    double balance = 0;
    for (final row in rows) {
      if (row.type == EntryType.credit.name) {
        balance += row.amount;
      } else {
        balance -= row.amount;
      }
    }
    return balance;
  }

  @override
  Future<List<Entry>> searchEntries(String query) async {
    final pattern = '%$query%';
    final rows = await (_db.select(_db.dbEntries)
          ..where(
            (tbl) => tbl.description.like(pattern) | tbl.tags.like(pattern),
          )
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.date, mode: OrderingMode.desc),
          ]))
        .get();

    return rows.map(_mapEntry).toList();
  }

  Entry _mapEntry(DbEntry row) {
    return Entry(
      id: row.id,
      customerId: row.customerId,
      type: EntryType.values.firstWhere(
        (value) => value.name == row.type,
        orElse: () => EntryType.debit,
      ),
      amount: row.amount,
      description: row.description,
      date: row.date,
      tags: (row.tags ?? '')
          .split(',')
          .where((tag) => tag.trim().isNotEmpty)
          .map((tag) => tag.trim())
          .toList(),
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
