class Directory {
  Directory(String path);

  Future<bool> exists() async => false;

  Future<Directory> create({bool recursive = false}) async => this;

  String get path => '';
}

class File {
  File(String path);

  Future<bool> exists() async => false;

  Future<File> copy(String newPath) async => this;

  Future<File> writeAsBytes(List<int> bytes, {bool flush = false}) async =>
      this;

  Future<String> readAsString() async =>
      throw UnsupportedError('File operations are not supported on the web.');

  String readAsStringSync() =>
      throw UnsupportedError('File operations are not supported on the web.');

  Future<List<int>> readAsBytes() async =>
      throw UnsupportedError('File operations are not supported on the web.');

  Future<void> writeAsString(String contents) async =>
      throw UnsupportedError('File operations are not supported on the web.');

  String get path => '';
}
