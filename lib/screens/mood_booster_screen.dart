import 'package:flutter/material.dart';

class MoodBoosterScreen extends StatefulWidget {
  const MoodBoosterScreen({super.key});

  @override
  State<MoodBoosterScreen> createState() => _MoodBoosterScreenState();
}

class _MoodBoosterScreenState extends State<MoodBoosterScreen> {
  String? _selected;

  final moods = ['😄', '😊', '😐', '😢', '😡'];

  void _confirmMood() {
    if (_selected != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Você está se sentindo: $_selected')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione um humor.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood Booster')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Como você está se sentindo?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: moods.map((emoji) {
                final selected = _selected == emoji;
                return GestureDetector(
                  onTap: () => setState(() => _selected = emoji),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: selected ? Colors.amber.withOpacity(0.3) : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _confirmMood,
              icon: const Icon(Icons.mood),
              label: const Text('Salvar'),
            )
          ],
        ),
      ),
    );
  }
}
