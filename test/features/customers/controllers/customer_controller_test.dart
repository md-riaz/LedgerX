import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ledgerx/data/datasources/ledger_database.dart';
import 'package:ledgerx/data/repositories/audit_repository_impl.dart';
import 'package:ledgerx/data/repositories/customer_repository_impl.dart';
import 'package:ledgerx/domain/entities/customer.dart';
import 'package:ledgerx/features/customers/controllers/customer_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.testMode = true;
  });

  group('CustomerController operations', () {
    late LedgerDatabase database;
    late CustomerRepositoryImpl repository;
    late CustomerController controller;

    setUp(() async {
      database = LedgerDatabase.forTesting(NativeDatabase.memory());
      final auditRepository = AuditRepositoryImpl(database: database);
      repository = CustomerRepositoryImpl(
        database: database,
        auditRepository: auditRepository,
      );
      controller = CustomerController(
        repository: repository,
        enableFeedback: false,
      );
      controller.onInit();
      await controller.loadCustomers();
    });

    tearDown(() async {
      await database.close();
      Get.deleteAll(force: true);
      Get.reset();
    });

    test('create, update and delete keep lists in sync', () async {
      expect(controller.customers, isEmpty);

      final createdAt = DateTime(2024, 1, 1);
      final customer = Customer(name: 'Alice', createdAt: createdAt, updatedAt: createdAt);

      final firstCreated =
          await controller.createCustomer(customer, closeAfterCreate: false);

      expect(firstCreated, isTrue);

      expect(controller.customers.length, 1);
      expect(controller.filteredCustomers.length, 1);

      final created = controller.customers.first;
      expect(created.id, isNotNull);

      final updated = created.copyWith(name: 'Alice Updated');
      await controller.updateCustomer(updated);

      expect(controller.customers.first.name, 'Alice Updated');

      await controller.deleteCustomer(created.id!);

      expect(controller.customers, isEmpty);
      expect(controller.filteredCustomers, isEmpty);
    });

    test('prevent duplicate customer creation', () async {
      final customer = Customer(name: 'Duplicate');

      final created =
          await controller.createCustomer(customer, closeAfterCreate: false);
      expect(created, isTrue);
      expect(controller.customers.length, 1);

      final duplicated =
          await controller.createCustomer(customer, closeAfterCreate: false);

      expect(duplicated, isFalse);
      expect(controller.customers.length, 1);
    });

    test('search and silent creation reuse cached data', () async {
      final bobCreated = await controller.createCustomer(
        Customer(name: 'Bob', phone: '123'),
        closeAfterCreate: false,
      );
      final charlieCreated = await controller.createCustomer(
        Customer(name: 'Charlie', notes: 'Friend'),
        closeAfterCreate: false,
      );

      expect(bobCreated, isTrue);
      expect(charlieCreated, isTrue);

      controller.searchCustomers('char');
      expect(controller.filteredCustomers.length, 1);
      expect(controller.filteredCustomers.first.name, 'Charlie');

      final found = await controller.findCustomerByName('bob');
      expect(found?.name, 'Bob');

      final again = await controller.createCustomerSilently('bob');
      expect(again.id, equals(found?.id));

      final fresh = await controller.createCustomerSilently('Dana');
      expect(fresh.name, 'Dana');
      expect(controller.customers.length, 3);
    });
  });
}
