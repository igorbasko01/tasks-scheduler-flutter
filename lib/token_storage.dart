import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class TokenStorage {
  Future<void> saveToken(String key, String value);
  Future<String?> getToken(String key);
  Future<Map<String, String>> getAll();
  Future<void> deleteToken(String key);
}

class SecureTokenStorage implements TokenStorage {
  final FlutterSecureStorage secureStorage;

  SecureTokenStorage({required this.secureStorage});

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