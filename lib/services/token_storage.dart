import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class TokenStorage {
  Future<void> saveToken(String key, String value);

  Future<String?> getToken(String key);

  Future<Map<String, String>> getAll();

  Future<void> deleteToken(String key);

  Stream<Map<String, String>> get allTokensStream;

  Future<void> refreshTokens();
}

class SecureTokenStorage implements TokenStorage {
  static SecureTokenStorage? _singleton;
  FlutterSecureStorage secureStorage;
  final _allTokensStreamController = StreamController<Map<String, String>>.broadcast();

  SecureTokenStorage._internal(this.secureStorage) {
    _updateTokensStream();
  }

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
  Future<void> refreshTokens() async {
    _updateTokensStream();
  }

  @override
  Stream<Map<String, String>> get allTokensStream => _allTokensStreamController.stream;

  @override
  Future<void> saveToken(String key, String value) async {
    await secureStorage.write(key: key, value: value);
    _updateTokensStream();
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
  Future<void> deleteToken(String key) async {
    await secureStorage.delete(key: key);
    _updateTokensStream();
  }

  Future<void> _updateTokensStream() async {
    _allTokensStreamController.add(await getAll());
  }
}
