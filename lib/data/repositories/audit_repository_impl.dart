import '../../domain/entities/audit_log.dart';
import '../datasources/database_helper.dart';

class AuditRepositoryImpl {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> logAction({
    required String action,
    required String entityType,
    int? entityId,
    String? details,
  }) async {
    final db = await _dbHelper.database;
    final log = AuditLog(
      action: action,
      entityType: entityType,
      entityId: entityId,
      details: details,
    );
    return await db.insert('audit_logs', log.toMap());
  }

  Future<List<AuditLog>> getAllLogs() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'audit_logs',
      orderBy: 'created_at DESC',
      limit: 1000,
    );
    return List.generate(maps.length, (i) => AuditLog.fromMap(maps[i]));
  }

  Future<List<AuditLog>> getLogsByEntity({
    required String entityType,
    int? entityId,
  }) async {
    final db = await _dbHelper.database;
    String where = 'entity_type = ?';
    List<dynamic> whereArgs = [entityType];
    
    if (entityId != null) {
      where += ' AND entity_id = ?';
      whereArgs.add(entityId);
    }
    
    final List<Map<String, dynamic>> maps = await db.query(
      'audit_logs',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) => AuditLog.fromMap(maps[i]));
  }

  Future<Map<String, int>> getActionStats() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT action, COUNT(*) as count FROM audit_logs GROUP BY action',
    );
    
    final stats = <String, int>{};
    for (var row in result) {
      stats[row['action'] as String] = row['count'] as int;
    }
    return stats;
  }
}
