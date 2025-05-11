import 'package:flutter/material.dart';

class MoodJournalScreen extends StatefulWidget {
  const MoodJournalScreen({super.key});

  @override
  State<MoodJournalScreen> createState() => _MoodJournalScreenState();
}

class _MoodJournalScreenState extends State<MoodJournalScreen> {
  final _controller = TextEditingController();

  void _saveNote() {
    final text = _controller.text;
    if (text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Salvo: "$text"')),
      );
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood Journal')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Escreva sobre como você está se sentindo:'),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite aqui...',
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _saveNote,
              child: const Text('Salvar'),
            )
          ],
        ),
      ),
    );
  }
}
