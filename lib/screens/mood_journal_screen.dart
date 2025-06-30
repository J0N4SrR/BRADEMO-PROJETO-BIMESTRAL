import 'package:flutter/material.dart';
import 'package:projeto_bimestral/services/database_service.dart';
import 'package:projeto_bimestral/theme/app_colors.dart';

class MoodJournalScreen extends StatefulWidget {
  const MoodJournalScreen({super.key});

  @override
  State<MoodJournalScreen> createState() => _MoodJournalScreenState();
}

class _MoodJournalScreenState extends State<MoodJournalScreen> {
  final _controller = TextEditingController();
  final List<Map<String, dynamic>> _mensagens = [];

  @override
  void initState() {
    super.initState();
    _carregarMensagens();
  }

  Future<void> _carregarMensagens() async {
  final mensagens = await DatabaseService().read('data2');
  print('Mensagens lidas: $mensagens'); // debug
  setState(() {
    _mensagens.clear();
    _mensagens.addAll(mensagens.reversed); // mais recentes primeiro
    });
  }

  void _editarMensagem(Map<String, dynamic> mensagemOriginal) {
  final TextEditingController editarController =
      TextEditingController(text: mensagemOriginal['mensagem']);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Editar mensagem'),
            content: TextField(
              controller: editarController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final novoTexto = editarController.text.trim();

                  if (novoTexto.isEmpty) return;

                  await DatabaseService().update(
                    path: 'data2/${mensagemOriginal['id']}',
                    data: {'mensagem': novoTexto},
                  );

                  Navigator.pop(context);
                  _carregarMensagens();
                },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _excluirMensagem(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir mensagem'),
        content: const Text('Tem certeza que deseja excluir esta mensagem?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              await DatabaseService().delete(path: 'data2/$id');
              Navigator.pop(context);
              _carregarMensagens();
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }


  String _formatarData(String isoString) {
    final date = DateTime.tryParse(isoString);
    if (date == null) return 'Data inválida';

    // Formato simples: 27/06/2025 às 22:12
    return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year} às '
          '${date.hour.toString().padLeft(2, '0')}:'
          '${date.minute.toString().padLeft(2, '0')}';
  }



  void _saveNote() {
  final text = _controller.text.trim();

  if (text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Digite algo antes de salvar.')),
    );
    return;
  }

  final data = {
  'mensagem': text,
  'timestamp': DateTime.now().toIso8601String(),
};

  DatabaseService()
      .create(path: 'data2', data: data)
      .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mensagem salva com sucesso!')),
        );
        _controller.clear();
        _carregarMensagens(); // atualiza a lista após salvar
      });
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
            ),
            const SizedBox(height: 24),
            const Text('Mensagens salvas:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: _mensagens.isEmpty
                  ? const Center(child: Text('Nenhuma mensagem encontrada.'))
                  : ListView.builder(
                      itemCount: _mensagens.length,
                      itemBuilder: (context, index) {
                        final msg = _mensagens[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(msg['mensagem'] ?? ''),
                              subtitle: msg['timestamp'] != null
                                  ? Text(_formatarData(msg['timestamp']))
                                  : null,
                              trailing: Row(
                              mainAxisSize: MainAxisSize.min, // evita ocupar espaço demais
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: AppColors.primary),
                                  tooltip: 'Editar',
                                  onPressed: () => _editarMensagem(msg),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: AppColors.primary),
                                  tooltip: 'Excluir',
                                  onPressed: () => _excluirMensagem(msg['id']),
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

