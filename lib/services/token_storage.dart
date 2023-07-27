import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class TokenStorage {
  Future<void> saveToken(String key, String value);

  Future<String?> getToken(String key);

  Future<Map<String, String>> getAll();

  Future<void> deleteToken(String key);
}

class SecureTokenStorage implements TokenStorage {
  static SecureTokenStorage? _singleton;
  FlutterSecureStorage secureStorage;

  SecureTokenStorage._internal(this.secureStorage);

  // Singleton implementation that allows us to provide a mock of FlutterSecureStorage
  factory SecureTokenStorage({FlutterSecureStorage? secureStorage}) {
    _singleton ??= SecureTokenStorage._internal(
        secureStorage ?? const FlutterSecureStorage());
    return _singleton!;
  }

  // For testing
  static void resetInstance() {
    _singleton = null;
  }

  @override
  Future<void> saveToken(String key, String value) async {
    await secureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> getToken(String key) async {
    return secureStorage.read(key: key);
  }

  @override
  Future<Map<String, String>> getAll() {
    return secureStorage.readAll();
  }

  @override
  Future<void> deleteToken(String key) {
    return secureStorage.delete(key: key);
  }
}
