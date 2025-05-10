import 'package:flutter/material.dart';
import 'package:projeto_bimestral/routes.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  _ShellScreenState createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _currentIndex = 0;

  final List<String> _routes = [
    Routes.welcome,
    Routes.list,
    Routes.form,
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    Navigator.pushNamed(context, _routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shell Screen')),
      drawer: const Drawer(child: Center(child: Text('Drawer'))),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
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
      body: const Center(child: Text('Tela com AppBar, Drawer, BottomNav e FAB')),
    );
  }
}
