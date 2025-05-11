import 'dart:math';
import 'package:flutter/material.dart';

class PositiveNotesScreen extends StatelessWidget {
  PositiveNotesScreen({super.key});

  final frases = [
    'Você é mais forte do que imagina.',
    'Tudo passa. Inclusive os dias ruins.',
    'Confie no seu processo.',
    'Você está no caminho certo!',
    'Uma coisa de cada vez.',
  ];

  @override
  Widget build(BuildContext context) {
    final random = frases[Random().nextInt(frases.length)];

    return Scaffold(
      appBar: AppBar(title: const Text('Positive Notes')),
      body: Center(
        child: Text(
          '"$random"',
          style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
