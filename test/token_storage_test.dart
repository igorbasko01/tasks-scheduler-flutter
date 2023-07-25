import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tasks_scheduler/token_storage.dart';

@GenerateNiceMocks([MockSpec<FlutterSecureStorage>()])
import 'token_storage_test.mocks.dart';

void main() {
  late TokenStorage tokenStorage;
  late FlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    when(mockSecureStorage.read(key: 'token')).thenAnswer((_) async => 'test_token');
    when(mockSecureStorage.read(key: 'non_token')).thenAnswer((_) async => null);
    when(mockSecureStorage.readAll()).thenAnswer((_) async => {'token': 'test_token'});
    when(mockSecureStorage.write(key: 'token', value: anyNamed('value'))).thenAnswer((_) async {});
    when(mockSecureStorage.delete(key: 'token')).thenAnswer((_) async {});

    tokenStorage = SecureTokenStorage(secureStorage: mockSecureStorage);
  });

  group('TokenStorage', () {
    test('stores a token', () async {
      await tokenStorage.saveToken('token', 'test_token');

      verify(mockSecureStorage.write(key: 'token', value: 'test_token')).called(1);
    });

    test('retrive a token by key', () async {
      var token = await tokenStorage.getToken('token');

      expect(token, 'test_token');
      verify(mockSecureStorage.read(key: 'token')).called(1);
    });
  });
}