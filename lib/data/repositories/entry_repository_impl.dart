import '../../domain/entities/entry.dart';
import '../../domain/repositories/entry_repository.dart';
import '../datasources/database_helper.dart';
import 'audit_repository_impl.dart';

class EntryRepositoryImpl implements EntryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final AuditRepositoryImpl _auditRepo = AuditRepositoryImpl();

  @override
  Future<List<Entry>> getAllEntries() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'entries',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Entry.fromMap(maps[i]));
  }

  @override
  Future<List<Entry>> getEntriesByCustomer(int customerId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'entries',
      where: 'customer_id = ?',
      whereArgs: [customerId],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Entry.fromMap(maps[i]));
  }

  @override
  Future<Entry?> getEntryById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'entries',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Entry.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<int> createEntry(Entry entry) async {
    final db = await _dbHelper.database;
    final id = await db.insert('entries', entry.toMap());
    
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
    final db = await _dbHelper.database;
    final result = await db.update(
      'entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
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
    final db = await _dbHelper.database;
    final result = await db.delete(
      'entries',
      where: 'id = ?',
      whereArgs: [id],
    );
    
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
    final entries = await getEntriesByCustomer(customerId);
    double balance = 0.0;
    
    for (var entry in entries) {
      if (entry.type == EntryType.credit) {
        balance += entry.amount;
      } else {
        balance -= entry.amount;
      }
    }
    
    return balance;
  }

  @override
  Future<List<Entry>> searchEntries(String query) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'entries',
      where: 'description LIKE ? OR tags LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Entry.fromMap(maps[i]));
  }
}
