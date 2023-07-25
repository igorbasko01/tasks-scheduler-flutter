import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class TokenStorage {
  Future<void> saveToken(String key, String value);
}

class SecureTokenStorage implements TokenStorage {
  final FlutterSecureStorage secureStorage;

  SecureTokenStorage({required this.secureStorage});

  @override
  Future<void> saveToken(String key, String value) {
    // TODO: implement saveToken
    throw UnimplementedError();
  }
}