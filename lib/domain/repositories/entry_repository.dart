import '../entities/entry.dart';

abstract class EntryRepository {
  Future<List<Entry>> getAllEntries();
  Future<List<Entry>> getEntriesByCustomer(int customerId);
  Future<Entry?> getEntryById(int id);
  Future<int> createEntry(Entry entry);
  Future<int> updateEntry(Entry entry);
  Future<int> deleteEntry(int id);
  Future<double> getBalance(int customerId);
  Future<List<Entry>> searchEntries(String query);
}
