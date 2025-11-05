import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';

Future<WasmDatabaseResult>? _opening;
WasmDatabaseResult? _cachedResult;
var _hasPendingSeed = false;

const String ledgerxDatabaseName = 'ledgerx_db';
final Uri _sqlite3Uri = Uri.parse('sqlite3.wasm');
final Uri _driftWorkerUri = Uri.parse('drift_worker.dart.js');

Future<WasmDatabaseResult> _openDatabase({Uint8List? seedBytes}) {
  return WasmDatabase.open(
    databaseName: ledgerxDatabaseName,
    sqlite3Uri: _sqlite3Uri,
    driftWorkerUri: _driftWorkerUri,
    initializeDatabase: seedBytes == null ? null : () => seedBytes,
  );
}

void prepareLedgerDatabaseOpening({Uint8List? seedBytes}) {
  _opening = _openDatabase(seedBytes: seedBytes);
  _hasPendingSeed = seedBytes != null;
}

bool consumePendingLedgerSeed() {
  final hadSeed = _hasPendingSeed;
  _hasPendingSeed = false;
  return hadSeed;
}

QueryExecutor createConnection() {
  return LazyDatabase(() async {
    _opening ??= _openDatabase();
    final result = await _opening!;
    _cachedResult = result;

    if (result.chosenImplementation == WasmStorageImplementation.inMemory) {
      if (kDebugMode) {
        // Surface a warning in debug consoles so developers know persistence is not available.
        // ignore: avoid_print
        print(
          'Warning: Falling back to an in-memory Drift database because '
          'persistent storage is unavailable in this browser. Data will not be saved.',
        );
      }
    }

    return result.resolvedExecutor.executor;
  });
}

Future<WasmProbeResult> _probeDatabase() {
  return WasmDatabase.probe(
    sqlite3Uri: _sqlite3Uri,
    driftWorkerUri: _driftWorkerUri,
    databaseName: ledgerxDatabaseName,
  );
}

WebStorageApi? _preferredStorageApi() {
  final implementation = _cachedResult?.chosenImplementation;
  return switch (implementation) {
    WasmStorageImplementation.opfsShared => WebStorageApi.opfs,
    WasmStorageImplementation.opfsLocks => WebStorageApi.opfs,
    WasmStorageImplementation.sharedIndexedDb => WebStorageApi.indexedDb,
    WasmStorageImplementation.unsafeIndexedDb => WebStorageApi.indexedDb,
    _ => null,
  };
}

ExistingDatabase? _selectExistingDatabase(
    Iterable<ExistingDatabase> databases) {
  ExistingDatabase? fallback;
  final preferredApi = _preferredStorageApi();

  for (final database in databases) {
    if (database.$2 != ledgerxDatabaseName) {
      continue;
    }

    fallback ??= database;
    if (preferredApi != null && database.$1 == preferredApi) {
      return database;
    }
  }

  return fallback;
}

Future<Uint8List?> exportLedgerDatabaseBytes() async {
  final probe = await _probeDatabase();
  final existing = _selectExistingDatabase(probe.existingDatabases);
  if (existing == null) {
    return null;
  }

  return probe.exportDatabase(existing);
}

Future<void> importLedgerDatabaseBytes(Uint8List bytes) async {
  final probe = await _probeDatabase();
  final matching = probe.existingDatabases
      .where((db) => db.$2 == ledgerxDatabaseName)
      .toList();

  for (final database in matching) {
    await probe.deleteDatabase(database);
  }

  prepareLedgerDatabaseOpening(seedBytes: bytes);
}
