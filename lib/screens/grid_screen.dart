import 'package:flutter/material.dart';

class GridScreen extends StatelessWidget {
  const GridScreen({super.key});

  final List<Map<String, dynamic>> items = const [
    {'icon': Icons.self_improvement, 'label': 'Meditação'},
    {'icon': Icons.music_note, 'label': 'Música'},
    {'icon': Icons.bedtime, 'label': 'Sono'},
    {'icon': Icons.favorite, 'label': 'Bem-estar'},
    {'icon': Icons.accessibility, 'label': 'Alongamento'},
    {'icon': Icons.spa, 'label': 'Relaxamento'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🚧 Ainda não implementado 🚧')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: items.map((item) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.teal.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item['icon'], size: 40, color: Colors.white),
                  const SizedBox(height: 12),
                  Text(
                    item['label'],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
