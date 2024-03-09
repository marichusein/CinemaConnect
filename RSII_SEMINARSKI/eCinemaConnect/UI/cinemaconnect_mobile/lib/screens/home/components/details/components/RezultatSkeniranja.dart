import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String message;

  ResultScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rezultat'),
      ),
      body: Center(
        child: Text(message),
      ),
    );
  }
}
