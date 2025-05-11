import 'package:flutter/material.dart';

class MoodBoosterScreen extends StatefulWidget {
  const MoodBoosterScreen({super.key});

  @override
  State<MoodBoosterScreen> createState() => _MoodBoosterScreenState();
}

class _MoodBoosterScreenState extends State<MoodBoosterScreen> {
  String? _selected;

  final moods = ['😄', '😊', '😐', '😢', '😡'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood Booster')),
      body: Center(
        child: Wrap(
          spacing: 20,
          children: moods.map((emoji) {
            final selected = _selected == emoji;
            return GestureDetector(
              onTap: () => setState(() => _selected = emoji),
              child: Text(
                emoji,
                style: TextStyle(fontSize: 40, backgroundColor: selected ? Colors.amber.withOpacity(0.3) : null),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
