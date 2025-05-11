import 'package:flutter/material.dart';

class Tool {
  final String label;
  final IconData icon;
  final Color color;
  final bool enabled;
  final String backgroundImage; 


  Tool({
    required this.label,
    required this.icon,
    required this.color,
    this.enabled = true,
    required this.backgroundImage,
  });
}
