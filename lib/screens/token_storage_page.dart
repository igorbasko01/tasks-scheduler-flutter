import 'package:flutter/material.dart';
import 'package:tasks_scheduler/services/token_storage.dart';

class TokenStoragePage extends StatelessWidget {
  final SecureTokenStorage tokenStorage = SecureTokenStorage();

  TokenStoragePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Token Storage')),
      body: const Center(
        child: Text('Token Storage Page'),
      ),
    );
  }
}