import 'dart:math';
import 'package:flutter/material.dart';
import 'package:projeto_bimestral/services/database_service.dart';
import 'package:projeto_bimestral/theme/app_colors.dart';

class PositiveNotesScreen extends StatefulWidget {
  const PositiveNotesScreen({super.key});

  @override
  State<PositiveNotesScreen> createState() => _PositiveNotesScreenState();
}

class _PositiveNotesScreenState extends State<PositiveNotesScreen> {
  final frases = [
    'Você é mais forte do que imagina.',
    'Tudo passa. Inclusive os dias ruins.',
    'Confie no seu processo.',
    'Você está no caminho certo!',
    'Uma coisa de cada vez.',
  ];

  final _controller = TextEditingController();
  List<Map<String, dynamic>> _notas = [];

  @override
  void initState() {
    super.initState();
    _carregarNotas();
  }

  void _salvarNota() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;

    final data = {
      'mensagem': texto,
      'timestamp': DateTime.now().toIso8601String(),
    };

    await DatabaseService().createUnique(path: 'positive_notes', data: data);
    _controller.clear();
    _carregarNotas();
  }

  void _carregarNotas() async {
    final notas = await DatabaseService().readList(path: 'positive_notes');
    setState(() => _notas = notas.reversed.toList());
  }

  void _editarNota(String id, String mensagemAtual) async {
    final controller = TextEditingController(text: mensagemAtual);

    final resultado = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Nota'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nova mensagem'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (resultado != null && resultado.isNotEmpty) {
      await DatabaseService().updatePositiveNote(id, {
        'mensagem': resultado,
        'timestamp': DateTime.now().toIso8601String(),
      });
      _carregarNotas();
    }
  }

  void _excluirNota(String id) async {
    await DatabaseService().deletePositiveNote(id);
    _carregarNotas();
  }


  @override
  Widget build(BuildContext context) {
    final random = frases[Random().nextInt(frases.length)];

    return Scaffold(
      appBar: AppBar(title: const Text('Positive Notes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '"$random"',
              style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Escreva sua nota positiva...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _salvarNota,
              child: const Text('Salvar Nota'),
            ),
            const SizedBox(height: 24),
            const Text('Minhas Notas:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: _notas.isEmpty
                  ? const Center(child: Text('Nenhuma nota positiva salva.'))
                  : ListView.builder(
                    itemCount: _notas.length,
                    itemBuilder: (context, index) {
                      final nota = _notas[index];
                      final id = nota['id'];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(nota['mensagem'] ?? ''),
                          subtitle: Text(nota['timestamp'] ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: AppColors.primary),
                                onPressed: () => _editarNota(id, nota['mensagem']),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: AppColors.primary),
                                onPressed: () => _excluirNota(id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
