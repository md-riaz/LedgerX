import 'package:flutter_test/flutter_test.dart';
import 'package:ledgerx/domain/entities/customer.dart';
import 'package:ledgerx/domain/entities/entry.dart';

void main() {
  group('Customer Entity Tests', () {
    test('Customer should be created with required fields', () {
      final customer = Customer(
        name: 'John Doe',
        email: 'john@example.com',
        phone: '1234567890',
      );

      expect(customer.name, 'John Doe');
      expect(customer.email, 'john@example.com');
      expect(customer.phone, '1234567890');
    });

    test('Customer should convert to and from map', () {
      final customer = Customer(
        id: 1,
        name: 'John Doe',
        email: 'john@example.com',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final map = customer.toMap();
      final customerFromMap = Customer.fromMap(map);

      expect(customerFromMap.id, customer.id);
      expect(customerFromMap.name, customer.name);
      expect(customerFromMap.email, customer.email);
    });
  });

  group('Entry Entity Tests', () {
    test('Entry should be created with required fields', () {
      final entry = Entry(
        customerId: 1,
        type: EntryType.credit,
        amount: 100.0,
        description: 'Test entry',
      );

      expect(entry.customerId, 1);
      expect(entry.type, EntryType.credit);
      expect(entry.amount, 100.0);
      expect(entry.description, 'Test entry');
    });

    test('Entry should convert to and from map', () {
      final entry = Entry(
        id: 1,
        customerId: 1,
        type: EntryType.debit,
        amount: 50.0,
        description: 'Test entry',
        date: DateTime(2024, 1, 1),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final map = entry.toMap();
      final entryFromMap = Entry.fromMap(map);

      expect(entryFromMap.id, entry.id);
      expect(entryFromMap.customerId, entry.customerId);
      expect(entryFromMap.type, entry.type);
      expect(entryFromMap.amount, entry.amount);
    });

    test('Entry should handle tags correctly', () {
      final entry = Entry(
        customerId: 1,
        type: EntryType.credit,
        amount: 100.0,
        tags: ['urgent', 'payment'],
      );

      expect(entry.tags.length, 2);
      expect(entry.tags.contains('urgent'), true);
      expect(entry.tags.contains('payment'), true);
    });
  });
}
