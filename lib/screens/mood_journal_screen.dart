import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projeto_bimestral/services/database_service.dart';
import 'package:projeto_bimestral/theme/app_colors.dart';
import 'package:geocoding/geocoding.dart';


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
    final mensagens = await DatabaseService().read('mood_journal');
    _mensagens.clear();

    for (final msg in mensagens.reversed) {
      if (msg['latitude'] != null && msg['longitude'] != null) {
        try {
          final placemarks = await placemarkFromCoordinates(
            msg['latitude'],
            msg['longitude'],
          );
          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            msg['local'] =
                '${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}';
          }
        } catch (_) {
          msg['local'] = 'Localização desconhecida';
        }
      }

      _mensagens.add(msg);
    }

    setState(() {});
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
                  path: 'mood_journal/${mensagemOriginal['id']}',
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
              await DatabaseService().delete(path: 'mood_journal/$id');
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

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} às '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  void _saveNote() async {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite algo antes de salvar.')),
      );
      return;
    }

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Permissão negada.');
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final data = {
        'mensagem': text,
        'timestamp': DateTime.now().toIso8601String(),
        'latitude': position.latitude,
        'longitude': position.longitude,
      };

      await DatabaseService().create(path: 'mood_journal', data: data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mensagem salva com sucesso!')),
      );

      _controller.clear();
      _carregarMensagens();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao obter localização: $e')),
      );
    }
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
                        final local = msg['local'] ?? 'Localização não disponível';
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(msg['mensagem'] ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (msg['timestamp'] != null)
                                  Text(_formatarData(msg['timestamp'])),
                                Text(local, style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
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
