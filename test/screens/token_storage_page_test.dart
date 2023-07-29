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
    when(tokenStorage.allTokensStream).thenAnswer((_) => Stream.value({}));
    when(tokenStorage.getAll()).thenAnswer((_) async => {});
    await tester.pumpWidget(MaterialApp(
      home: TokenStoragePage(tokenStorage: tokenStorage),
    ));
    await tester.pump();
    
    expect(find.text('No tokens found'), findsOneWidget);
      });
  
  testWidgets('TokenStoragePage shows "Tokens found" when there are tokens', (tester) async {
    when(tokenStorage.allTokensStream).thenAnswer((_) => Stream.value({'token': 'test_token'}));
    when(tokenStorage.getAll()).thenAnswer((_) async => {'token': 'test_token'});
    await tester.pumpWidget(MaterialApp(
      home: TokenStoragePage(tokenStorage: tokenStorage),
    ));
    await tester.pump();

    expect(find.text('Key: token'), findsOneWidget);
    expect(find.text('Value: test_token'), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);
  });
  
  testWidgets('Token dialog test', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: TokenStoragePage(tokenStorage: tokenStorage),
    ));
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(TextButton), findsNWidgets(2));

    await tester.enterText(find.widgetWithText(TextField, 'Enter Key'), 'test_key');
    await tester.enterText(find.widgetWithText(TextField, 'Enter token'), 'test_token');

    await tester.tap(find.widgetWithText(TextButton, 'Add'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);

    verify(tokenStorage.saveToken('test_key', 'test_token')).called(1);
  });

  testWidgets('TokenStoragePage calls SecureTokenStorage delete when the delete icon pressed', (tester) async {
    when(tokenStorage.allTokensStream).thenAnswer((_) => Stream.value({'token': 'test_token'}));
    await tester.pumpWidget(MaterialApp(
      home: TokenStoragePage(tokenStorage: tokenStorage),
    ));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.delete));

    verify(tokenStorage.deleteToken('token')).called(1);
  });
}