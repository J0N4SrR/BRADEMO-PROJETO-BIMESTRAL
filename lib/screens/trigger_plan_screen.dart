import 'package:flutter/material.dart';

class TriggerPlanScreen extends StatefulWidget {
  const TriggerPlanScreen({super.key});

  @override
  State<TriggerPlanScreen> createState() => _TriggerPlanScreenState();
}

class _TriggerPlanScreenState extends State<TriggerPlanScreen> {
  final List<Map<String, dynamic>> _steps = [
    {'title': 'Respirar fundo', 'done': false},
    {'title': 'Tomar água', 'done': false},
    {'title': 'Fazer uma pausa', 'done': false},
    {'title': 'Conversar com alguém', 'done': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trigger Plan')),
      body: ListView(
        children: _steps.map((step) {
          return CheckboxListTile(
            title: Text(step['title']),
            value: step['done'],
            onChanged: (val) {
              setState(() => step['done'] = val);
            },
          );
        }).toList(),
      ),
    );
  }
}
