import 'package:flutter/material.dart';
import '../models/tool.dart';

class ToolCard extends StatelessWidget {
  final Tool tool;
  final VoidCallback? onTap;

  const ToolCard({super.key, required this.tool, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tool.enabled ? onTap : null,
      child: AnimatedOpacity(
        opacity: tool.enabled ? 1.0 : 0.5,
        duration: const Duration(milliseconds: 300),
        child: Container(
          decoration: BoxDecoration(
            color: tool.color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    tool.backgroundImage,
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.2),
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(tool.icon, size: 32, color: Colors.white),
                      const SizedBox(height: 12),
                      Text(
                        tool.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
