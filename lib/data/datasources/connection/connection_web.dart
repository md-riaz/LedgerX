import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

Future<WasmDatabaseResult>? _opening;

QueryExecutor createConnection() {
  return LazyDatabase(() async {
    final result = await (_opening ??= WasmDatabase.open(
      databaseName: 'ledgerx_db',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.dart.js'),
    ));

    if (result.chosenImplementation == WasmStorageImplementation.inMemory) {
      // Surface a warning in debug consoles so developers know persistence is not available.
      // ignore: avoid_print
      print(
        'Warning: Falling back to an in-memory Drift database because '
        'persistent storage is unavailable in this browser. Data will not be saved.',
      );
    }

    return result.resolvedExecutor.executor;
  });
}
