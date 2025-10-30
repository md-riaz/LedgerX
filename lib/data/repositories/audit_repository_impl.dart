import 'package:drift/drift.dart';

import '../../domain/entities/audit_log.dart';
import '../datasources/ledger_database.dart';

class AuditRepositoryImpl {
  AuditRepositoryImpl({LedgerDatabase? database})
      : _db = database ?? LedgerDatabase();

  final LedgerDatabase _db;

  Future<int> logAction({
    required String action,
    required String entityType,
    int? entityId,
    String? details,
  }) async {
    final now = DateTime.now();
    return await _db.into(_db.dbAuditLogs).insert(
          DbAuditLogsCompanion.insert(
            action: action,
            entityType: entityType,
            entityId: entityId == null ? const Value.absent() : Value(entityId),
            details: details == null ? const Value.absent() : Value(details),
            createdAt: Value(now),
          ),
        );
  }

  Future<List<AuditLog>> getAllLogs() async {
    final query = _db.select(_db.dbAuditLogs)
      ..orderBy([
        (tbl) =>
            OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
      ])
      ..limit(1000);

    final rows = await query.get();
    return rows.map(_mapAuditLog).toList();
  }

  Future<List<AuditLog>> getLogsByEntity({
    required String entityType,
    int? entityId,
  }) async {
    final query = _db.select(_db.dbAuditLogs)
      ..where((tbl) => tbl.entityType.equals(entityType));

    if (entityId != null) {
      query.where((tbl) => tbl.entityId.equals(entityId));
    }

    query.orderBy([
      (tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
    ]);

    final rows = await query.get();
    return rows.map(_mapAuditLog).toList();
  }

  Future<Map<String, int>> getActionStats() async {
    final rows = await _db
        .customSelect(
          'SELECT action, COUNT(*) AS count FROM db_audit_logs GROUP BY action',
        )
        .get();

    final stats = <String, int>{};
    for (final row in rows) {
      final action = row.read<String>('action');
      final count = row.read<int>('count');
      stats[action] = count;
    }
    return stats;
  }

  AuditLog _mapAuditLog(DbAuditLog row) {
    return AuditLog(
      id: row.id,
      action: row.action,
      entityType: row.entityType,
      entityId: row.entityId,
      details: row.details,
      createdAt: row.createdAt,
    );
  }
}
