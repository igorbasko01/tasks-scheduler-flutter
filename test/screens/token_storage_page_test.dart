import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_scheduler/services/token_storage.dart';
import 'package:tasks_scheduler/screens/token_storage_page.dart';
import 'package:flutter_test/flutter_test.dart';

@GenerateNiceMocks([MockSpec<TokenStorage>()])
import 'token_storage_page_test.mocks.dart';

void main() {
  late TokenStorage tokenStorage;

  setUp(() {
    tokenStorage = MockTokenStorage();
  });

  testWidgets(
      'TokenStoragePage shows "No tokens found" when there are no tokens', (tester) async {
    when(tokenStorage.getAll()).thenAnswer((_) async => {});
    await tester.pumpWidget(MaterialApp(
      home: TokenStoragePage(tokenStorage: tokenStorage),
    ));
    await tester.pump();
    
    expect(find.text('No tokens found'), findsOneWidget);
      });
  
  testWidgets('TokenStoragePage shows "Tokens found" when there are tokens', (tester) async {
    when(tokenStorage.getAll()).thenAnswer((_) async => {'token': 'test_token'});
    await tester.pumpWidget(MaterialApp(
      home: TokenStoragePage(tokenStorage: tokenStorage),
    ));
    await tester.pump();

    expect(find.text('Tokens found'), findsOneWidget);
  });
}