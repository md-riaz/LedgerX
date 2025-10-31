// ignore_for_file: deprecated_member_use

import 'package:drift/drift.dart';
import 'package:drift/web.dart';

QueryExecutor createConnection() {
  final storage = DriftWebStorage.indexedDb('ledgerx_db');
  return WebDatabase.driver(storage: storage);
}
