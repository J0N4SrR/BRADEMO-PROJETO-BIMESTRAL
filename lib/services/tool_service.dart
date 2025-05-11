import 'package:flutter/material.dart';
import '../models/tool.dart'; 

class ToolService {
  static List<Tool> getTools() {
    return [
      Tool(
        label: 'Mood Journal',
        icon: Icons.book,
        color: Colors.teal.shade700,
        backgroundImage: 'assets/images/mountaineers.png',
      ),
      Tool(
        label: 'Mood Booster',
        icon: Icons.rocket_launch,
        color: Colors.teal.shade500,
        backgroundImage: 'assets/images/lovely_deserts.png',
      ),
      Tool(
        label: 'Positive Notes',
        icon: Icons.sentiment_satisfied_alt,
        color: Colors.green.shade400,
        backgroundImage: 'assets/images/the_hill_sides.png',
      ),
      Tool(
        label: 'Trigger Plan',
        icon: Icons.auto_fix_high,
        color: Colors.green.shade600,
        backgroundImage: 'assets/images/painting_forest.png',
      ),
    ];
  }
}
