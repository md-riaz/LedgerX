import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledgerx/data/datasources/ledger_database.dart';
import 'package:ledgerx/data/repositories/audit_repository_impl.dart';
import 'package:ledgerx/data/repositories/customer_repository_impl.dart';
import 'package:ledgerx/data/repositories/entry_repository_impl.dart';
import 'package:ledgerx/domain/entities/customer.dart';
import 'package:ledgerx/domain/entities/entry.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EntryRepositoryImpl operations', () {
    late LedgerDatabase database;
    late AuditRepositoryImpl auditRepository;
    late CustomerRepositoryImpl customerRepository;
    late EntryRepositoryImpl entryRepository;
    late int customerId;

    setUp(() async {
      database = LedgerDatabase.forTesting(NativeDatabase.memory());
      auditRepository = AuditRepositoryImpl(database: database);
      customerRepository = CustomerRepositoryImpl(
        database: database,
        auditRepository: auditRepository,
      );
      entryRepository = EntryRepositoryImpl(
        database: database,
        auditRepository: auditRepository,
      );

      customerId = await customerRepository.createCustomer(
        Customer(name: 'Test Customer'),
      );
    });

    tearDown(() async {
      await database.close();
    });

    test('create, update, delete and search entries with balance tracking', () async {
      final creditEntry = Entry(
        customerId: customerId,
        type: EntryType.credit,
        amount: 200,
        description: 'Initial deposit',
        tags: ['opening'],
      );

      final creditId = await entryRepository.createEntry(creditEntry);
      var allEntries = await entryRepository.getAllEntries();
      expect(allEntries.length, 1);
      expect(allEntries.first.amount, 200);

      final updatedCredit = creditEntry.copyWith(
        id: creditId,
        amount: 220,
        description: 'Updated deposit',
        tags: ['opening', 'adjustment'],
      );
      await entryRepository.updateEntry(updatedCredit);
      final fetched = await entryRepository.getEntryById(creditId);
      expect(fetched?.amount, 220);
      expect(fetched?.description, 'Updated deposit');
      expect(fetched?.tags, contains('adjustment'));

      final debitEntry = Entry(
        customerId: customerId,
        type: EntryType.debit,
        amount: 40,
        description: 'Office supplies',
        tags: ['office'],
      );
      final debitId = await entryRepository.createEntry(debitEntry);

      final balance = await entryRepository.getBalance(customerId);
      expect(balance, 180);

      final byCustomer = await entryRepository.getEntriesByCustomer(customerId);
      expect(byCustomer.length, 2);
      expect(byCustomer.firstWhere((entry) => entry.id == debitId).description,
          'Office supplies');

      final searchResults = await entryRepository.searchEntries('office');
      expect(searchResults.length, 1);
      expect(searchResults.first.id, debitId);

      await entryRepository.deleteEntry(debitId);
      allEntries = await entryRepository.getAllEntries();
      expect(allEntries.length, 1);
    });
  });
}
