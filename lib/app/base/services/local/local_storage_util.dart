import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class LocalStorageUtil {
  Future<void> write({required String key, required String value});

  Future<String?> read({required String key});

  Future<void> delete({required String key});
}

class SecureStorageUtil extends LocalStorageUtil {
  late final FlutterSecureStorage _storage;

  SecureStorageUtil() {
    _storage = const FlutterSecureStorage();
  }

  @override
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read({required String key}) async => _storage.read(key: key);

  @override
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }
}
