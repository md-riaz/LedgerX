import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:intl/intl.dart';
import 'package:ledgerx/data/datasources/ledger_database.dart';
import 'package:ledgerx/utils/io_stub.dart' if (dart.library.io) 'dart:io'
    as io;
import 'package:ledgerx/utils/platform_utils.dart';
import 'package:path/path.dart' as p;

class BackupServiceException implements Exception {
  const BackupServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}

class BackupService {
  BackupService({
    LedgerDatabase? database,
    FilePicker? filePicker,
  })  : _databaseOverride = database,
        _filePicker = filePicker ?? FilePicker.platform;

  final LedgerDatabase? _databaseOverride;
  final FilePicker _filePicker;

  LedgerDatabase get _database => _databaseOverride ?? LedgerDatabase();

  Future<String?> backupDatabase() async {
    final backupData = await _database.exportDatabaseBytes();
    if (backupData == null || backupData.isEmpty) {
      throw const BackupServiceException('ডাটাবেস ফাইল খুঁজে পাওয়া যায়নি।');
    }

    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final backupFileName = 'ledgerx_backup_$timestamp.db';

    if (PlatformUtils.isWeb) {
      await FileSaver.instance.saveFile(
        name: backupFileName,
        bytes: backupData,
        mimeType: MimeType.other,
      );
      return backupFileName;
    }

    final dbFile = await _database.databaseFilePath();
    if (dbFile == null) {
      throw const BackupServiceException(
          'ডাটাবেস ফাইলের অবস্থান নির্ণয় করা যায়নি।');
    }

    if (PlatformUtils.isDesktop) {
      final directoryPath = await _filePicker.getDirectoryPath(
        dialogTitle: 'ব্যাকআপ সংরক্ষণের স্থান নির্বাচন করুন',
      );

      if (directoryPath == null) {
        return null;
      }

      final backupFile = io.File(p.join(directoryPath, backupFileName));
      await backupFile.writeAsBytes(backupData, flush: true);
      return backupFile.path;
    }

    String? savePath;
    try {
      savePath = await _filePicker.saveFile(
        dialogTitle: 'ব্যাকআপ ফাইল সংরক্ষণ করুন',
        fileName: backupFileName,
        type: FileType.custom,
        allowedExtensions: const ['db'],
      );
    } on UnsupportedError {
      savePath = null;
    }

    if (savePath == null) {
      await FileSaver.instance.saveFile(
        name: backupFileName,
        bytes: backupData,
        mimeType: MimeType.other,
      );
      return backupFileName;
    }

    final destinationDir = io.Directory(p.dirname(savePath));
    if (!await destinationDir.exists()) {
      await destinationDir.create(recursive: true);
    }

    final destinationFile = io.File(savePath);
    await destinationFile.writeAsBytes(backupData, flush: true);
    return destinationFile.path;
  }

  Future<bool> restoreDatabase() async {
    final result = await _filePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['db'],
      allowMultiple: false,
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return false;
    }

    final platformFile = result.files.single;

    final Uint8List? selectedBytes =
        platformFile.bytes ?? await _readBytesFromPath(platformFile.path);

    if (selectedBytes == null || selectedBytes.isEmpty) {
      throw const BackupServiceException('নির্বাচিত ফাইলের ডেটা পড়া যায়নি।');
    }

    await _database.close();

    await _database.importDatabaseFromBytes(selectedBytes);

    await _database.reopen();

    return true;
  }

  Future<Uint8List?> _readBytesFromPath(String? path) async {
    if (path == null || path.isEmpty) {
      return null;
    }

    try {
      final file = io.File(path);
      if (!await file.exists()) {
        return null;
      }
      final bytes = await file.readAsBytes();
      return Uint8List.fromList(bytes);
    } catch (_) {
      return null;
    }
  }
}
