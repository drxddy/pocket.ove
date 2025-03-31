import 'package:flutter/material.dart';

class PocketApp extends StatefulWidget {
  const PocketApp({super.key});

  @override
  State<PocketApp> createState() => _PocketAppState();
}

class _PocketAppState extends State<PocketApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pocket App'),
      ),
      body: Center(
        child: const Text('Welcome to Pocket App!'),
      ),
    );
  }
}
