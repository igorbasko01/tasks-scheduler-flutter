import 'package:flutter/material.dart';
import 'package:tasks_scheduler/services/token_storage.dart';

class TokenStoragePage extends StatelessWidget {
  final TokenStorage tokenStorage;

  TokenStoragePage({Key? key, TokenStorage? tokenStorage})
      : tokenStorage = tokenStorage ?? SecureTokenStorage(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tokens Page')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // "Add Token" code here.
        },
        tooltip: 'Add token',
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: tokenStorage.getAll(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // We have data !
            Map<String, String> tokens = snapshot.data!;
            if (tokens.isEmpty) {
              return const Center(child: Text('No tokens found'));
            } else {
              return const Center(child: Text('Tokens found'));
            }
          }
        },
      ),
    );
  }
}
