import 'package:flutter/material.dart';
import 'package:projeto_bimestral/routes.dart';
import 'package:projeto_bimestral/services/tool_service.dart';
import 'package:projeto_bimestral/widgets/tool_card.dart';

class ShellScreen extends StatelessWidget {
  const ShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = ToolService.getTools();
    final String? userName = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/lotus.png', height: 28),
            const SizedBox(width: 8),
            const Text('Tools'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.teal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/user.png'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Olá, ${userName ?? 'Bem vindo'}! 🌷',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Mood Journal'),
              onTap: () => Navigator.pushNamed(context, Routes.moodJournal),
            ),
            ListTile(
              leading: const Icon(Icons.rocket_launch),
              title: const Text('Mood Booster'),
              onTap: () => Navigator.pushNamed(context, Routes.moodBooster),
            ),
            ListTile(
              leading: const Icon(Icons.sentiment_satisfied_alt),
              title: const Text('Positive Notes'),
              onTap: () => Navigator.pushNamed(context, Routes.positiveNotes),
            ),
            ListTile(
              leading: const Icon(Icons.check_box),
              title: const Text('Trigger Plan'),
              onTap: () => Navigator.pushNamed(context, Routes.triggerPlan),
            ),
            ListTile(
              leading: const Icon(Icons.grid_view),
              title: const Text('Grade'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Routes.grid);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Lista de Itens'),
              onTap: () => Navigator.pushNamed(context, Routes.list),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Formulário'),
              onTap: () => Navigator.pushNamed(context, Routes.form),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {          
          if (index == 0) Navigator.pushNamed(context, Routes.list);
          if (index == 1) Navigator.pushNamed(context, Routes.form);
          if (index == 2) Navigator.pushNamed(context, Routes.welcome);
        },
        items: const [          
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Form'),
          BottomNavigationBarItem(icon: Icon(Icons.arrow_back	), label: 'Sair'),
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
