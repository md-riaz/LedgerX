import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:ledgerx/utils/io_stub.dart' if (dart.library.io) 'dart:io'
    as io;
import 'package:ledgerx/utils/platform_utils.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

QueryExecutor createConnection() {
  return LazyDatabase(() async {
    final docDir = await getApplicationDocumentsDirectory();
    String dbPath;

    if (PlatformUtils.isDesktop) {
      final dataDir = io.Directory(p.join(docDir.path, 'LedgerX', 'data'));
      if (!await dataDir.exists()) {
        await dataDir.create(recursive: true);
      }
      dbPath = p.join(dataDir.path, 'ledgerx.db');
    } else {
      dbPath = p.join(docDir.path, 'ledgerx.db');
    }

    final file = io.File(dbPath);
    // Cast to dynamic so compilation succeeds when using the web stub implementation.
    return NativeDatabase.createInBackground(file as dynamic);
  });
}
