import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

var logger = Logger();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks Scheduler',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Tasks Scheduler Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  void _printHelloWorld() {
    logger.i('Hello World !');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          PopupMenuButton<String>(
              onSelected: (String result) {
                logger.i(result);
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'API Tokens',
                      child: Text('Api Tokens'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Logout',
                      child: Text('Logout'),
                    ),
                  ],
              icon: const Icon(Icons.menu)
          )
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _printHelloWorld,
          child: const Text('Press Me'),
        ),
      ),
    );
  }
}
