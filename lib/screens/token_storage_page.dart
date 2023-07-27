import 'package:flutter/material.dart';
import 'package:tasks_scheduler/services/token_storage.dart';

class TokenStoragePage extends StatelessWidget {
  final SecureTokenStorage tokenStorage = SecureTokenStorage();

  TokenStoragePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: tokenStorage.getAll(),
      builder: (BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        } else {
          // We have data !
          Map<String, String> tokens = snapshot.data!;
          if (tokens.isEmpty) {
            return Scaffold(
              appBar: AppBar(title: const Text('Tokens Page'),),
              body: const Center(child: Text('No tokens found')),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // Add token code here.
                },
                tooltip: 'Add token',
                child: const Icon(Icons.add),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(title: const Text('Tokens Page')),
              body: const Center(child: Text('Tokens found')),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // Add token code here.
                },
                tooltip: 'Add token',
                child: const Icon(Icons.add),
              ),
            );
          }
        }
      }
    );
  }
}