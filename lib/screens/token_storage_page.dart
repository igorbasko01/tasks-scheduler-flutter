import 'package:flutter/material.dart';
import 'package:tasks_scheduler/services/token_storage.dart';

class TokenStoragePage extends StatelessWidget {
  final TokenStorage tokenStorage;

  TokenStoragePage({Key? key, TokenStorage? tokenStorage})
      : tokenStorage = tokenStorage ?? SecureTokenStorage(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    tokenStorage.refreshTokens();
    return Scaffold(
      appBar: AppBar(title: const Text('Tokens Page')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTokenDialog(context),
        tooltip: 'Add token',
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<Map<String, String>>(
        stream: tokenStorage.allTokensStream,
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // We have data !
            Map<String, String>? tokens = snapshot.data;
            if (tokens == null || tokens.isEmpty) {
              return const Center(child: Text('No tokens found'));
            } else {
              return const Center(child: Text('Tokens found'));
            }
          }
        },
      ),
    );
  }

  void _showAddTokenDialog(BuildContext context) {
    final TextEditingController keyController = TextEditingController();
    final TextEditingController tokenController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Token'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: keyController,
                decoration: const InputDecoration(hintText: 'Enter Key'),
              ),
              TextField(
                controller: tokenController,
                decoration: const InputDecoration(hintText: 'Enter token'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                tokenStorage.saveToken(
                    keyController.text, tokenController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
