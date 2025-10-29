import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/database_helper.dart';
import 'audit_repository_impl.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final AuditRepositoryImpl _auditRepo = AuditRepositoryImpl();

  @override
  Future<List<Customer>> getAllCustomers() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'customers',
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => Customer.fromMap(maps[i]));
  }

  @override
  Future<Customer?> getCustomerById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Customer.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<int> createCustomer(Customer customer) async {
    final db = await _dbHelper.database;
    final id = await db.insert('customers', customer.toMap());
    
    await _auditRepo.logAction(
      action: 'CREATE',
      entityType: 'Customer',
      entityId: id,
      details: 'Created customer: ${customer.name}',
    );
    
    return id;
  }

  @override
  Future<int> updateCustomer(Customer customer) async {
    final db = await _dbHelper.database;
    final result = await db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
    
    await _auditRepo.logAction(
      action: 'UPDATE',
      entityType: 'Customer',
      entityId: customer.id,
      details: 'Updated customer: ${customer.name}',
    );
    
    return result;
  }

  @override
  Future<int> deleteCustomer(int id) async {
    final customer = await getCustomerById(id);
    final db = await _dbHelper.database;
    final result = await db.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    await _auditRepo.logAction(
      action: 'DELETE',
      entityType: 'Customer',
      entityId: id,
      details: 'Deleted customer: ${customer?.name ?? 'Unknown'}',
    );
    
    return result;
  }

  @override
  Future<List<Customer>> searchCustomers(String query) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'customers',
      where: 'name LIKE ? OR email LIKE ? OR phone LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => Customer.fromMap(maps[i]));
  }
}
