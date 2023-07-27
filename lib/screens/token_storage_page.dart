import 'package:flutter/material.dart';

class TokenStoragePage extends StatelessWidget {
  const TokenStoragePage({Key? key}) : super(key: key);

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