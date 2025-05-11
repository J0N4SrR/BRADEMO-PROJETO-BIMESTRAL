import 'package:flutter/material.dart';
import 'package:projeto_bimestral/routes.dart';
import 'package:projeto_bimestral/services/tool_service.dart';
import 'package:projeto_bimestral/widgets/tool_card.dart';

class ShellScreen extends StatelessWidget {
  const ShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = ToolService.getTools();

    return Scaffold(
      appBar: AppBar(title: const Text('Tools')),
      drawer: const Drawer(child: Center(child: Text('Drawer'))),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) Navigator.pushNamed(context, Routes.list);
          if (index == 2) Navigator.pushNamed(context, Routes.form);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Form'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.form);
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: tools.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final tool = tools[index];
            return ToolCard(
              tool: tool,
              onTap: () {
                 switch (tool.label) {
                  case 'Mood Journal':
                    Navigator.pushNamed(context, Routes.moodJournal);
                    break;
                  case 'Mood Booster':
                    Navigator.pushNamed(context, Routes.moodBooster);
                    break;
                  case 'Positive Notes':
                    Navigator.pushNamed(context, Routes.positiveNotes);
                    break;
                  case 'Trigger Plan':
                    Navigator.pushNamed(context, Routes.triggerPlan);
                    break;
              }
            },

            );
          },
        ),
      ),
    );
  }
}
