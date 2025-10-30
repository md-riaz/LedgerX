import 'ledger_database.dart';

@Deprecated(
    'DatabaseHelper has been replaced by LedgerDatabase. Use LedgerDatabase() instead.')
class DatabaseHelper {
  DatabaseHelper._();

  static final LedgerDatabase _database = LedgerDatabase();

  static LedgerDatabase get instance => _database;
}
