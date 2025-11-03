import 'package:drift/drift.dart';

import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/ledger_database.dart';
import 'audit_repository_impl.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  CustomerRepositoryImpl({
    LedgerDatabase? database,
    AuditRepositoryImpl? auditRepository,
  })  : _db = database ?? LedgerDatabase(),
        _auditRepo = auditRepository ??
            AuditRepositoryImpl(database: database ?? LedgerDatabase());

  final LedgerDatabase _db;
  final AuditRepositoryImpl _auditRepo;

  @override
  Future<List<Customer>> getAllCustomers() async {
    final query = _db.select(_db.dbCustomers)
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.name)]);
    final rows = await query.get();
    return rows.map(_mapCustomer).toList();
  }

  @override
  Future<Customer?> getCustomerById(int id) async {
    final row = await (_db.select(_db.dbCustomers)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _mapCustomer(row);
  }

  @override
  Future<Customer?> getCustomerByNameInsensitive(String name) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return null;
    }

    final row = await (_db.select(_db.dbCustomers)
          ..where(
            (tbl) =>
                tbl.name.collate(Collate.noCase).equals(trimmedName),
          )
          ..limit(1))
        .getSingleOrNull();

    return row == null ? null : _mapCustomer(row);
  }

  @override
  Future<int> createCustomer(Customer customer) async {
    final id = await _db.into(_db.dbCustomers).insert(
          DbCustomersCompanion.insert(
            name: customer.name,
            phone: customer.phone == null
                ? const Value.absent()
                : Value(customer.phone!),
            address: customer.address == null
                ? const Value.absent()
                : Value(customer.address!),
            notes: customer.notes == null
                ? const Value.absent()
                : Value(customer.notes!),
            createdAt: Value(customer.createdAt),
            updatedAt: Value(customer.updatedAt),
          ),
        );

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
    if (customer.id == null) {
      throw ArgumentError('Customer ID is required for update');
    }

    final result = await (_db.update(_db.dbCustomers)
          ..where((tbl) => tbl.id.equals(customer.id!)))
        .write(
      DbCustomersCompanion(
        name: Value(customer.name),
        phone: customer.phone == null
            ? const Value.absent()
            : Value(customer.phone!),
        address: customer.address == null
            ? const Value.absent()
            : Value(customer.address!),
        notes: customer.notes == null
            ? const Value.absent()
            : Value(customer.notes!),
        updatedAt: Value(customer.updatedAt),
      ),
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
    final result = await (_db.delete(_db.dbCustomers)
          ..where((tbl) => tbl.id.equals(id)))
        .go();

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
    final pattern = '%$query%';
    final rows = await (_db.select(_db.dbCustomers)
          ..where(
            (tbl) =>
                tbl.name.like(pattern) |
                tbl.phone.like(pattern) |
                tbl.address.like(pattern) |
                tbl.notes.like(pattern),
          )
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.name)]))
        .get();

    return rows.map(_mapCustomer).toList();
  }

  Customer _mapCustomer(DbCustomer row) {
    return Customer(
      id: row.id,
      name: row.name,
      phone: row.phone,
      address: row.address,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
