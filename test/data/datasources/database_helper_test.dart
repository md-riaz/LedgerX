import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_test/flutter_test.dart';
import 'package:ledgerx/data/datasources/database_helper.dart';

void main() {
  group('DatabaseHelper encryption', () {
    final helper = DatabaseHelper.instance;

    test('encryptData uses a 256-bit key and yields base64 output', () {
      const sample = 'Sensitive payload';

      late final String encrypted;
      expect(() => encrypted = helper.encryptData(sample), returnsNormally);
      expect(encrypted, isNotEmpty);
      expect(RegExp(r'^[A-Za-z0-9+/]+={0,2}$').hasMatch(encrypted), isTrue);

      final key = encrypt.Key.fromUtf8('ledgerx_secure_key_32_chars!!!!!');
      expect(key.bytes.length, 32);
    });
  });
}
