import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_bimestral/services/database_service.dart';
import 'package:projeto_bimestral/theme/app_colors.dart';



class MoodBoosterScreen extends StatefulWidget {
  const MoodBoosterScreen({super.key});

  @override
  State<MoodBoosterScreen> createState() => _MoodBoosterScreenState();
  
}

class _MoodBoosterScreenState extends State<MoodBoosterScreen> {
  String? _selected;
  XFile? _pickedImage;
  List<Map<String, dynamic>> _historico = [];
  final TextEditingController _mensagemController = TextEditingController();
  

  @override
    void initState() {
    super.initState();
    _carregarEmojiSalvo();
    _carregarHistorico();
  }

  Future<void> _carregarHistorico() async {
    final dados = await DatabaseService().getMoodHistory();
    setState(() {
      _historico = dados;
    });
  }

  Future<void> _carregarEmojiSalvo() async {
    final emoji = await DatabaseService().getSavedMoodEmoji();
    if (emoji != null) {
      setState(() {
        _selected = emoji;
      });
    }
  }


  final moods = ['😄', '😊', '😐', '😢', '😡'];

  void _confirmMood() async {
    final mensagem = _mensagemController.text.trim();
    if (_selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecione o humor.')));
      return;
    }

    String? imageUrl;
    if (_pickedImage != null) {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      imageUrl = await DatabaseService().uploadMoodImage(id, _pickedImage!);
    }

    await DatabaseService().saveMoodToHistory(
      emoji: _selected!,
      mensagem: mensagem,
      imageUrl: imageUrl,
    );

    setState(() => _pickedImage = null);
    _mensagemController.clear();
    _carregarHistorico();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Humor salvo: $_selected')));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood Booster')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Como você está se sentindo?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: moods.map((emoji) {
                final selected = _selected == emoji;
                return GestureDetector(
                  onTap: () => setState(() => _selected = emoji),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: selected ? Colors.amber.withOpacity(0.3) : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                );
              }).toList(),
            ),
            TextField(
              controller: _mensagemController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escreva uma breve mensagem sobre seu humor...',
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _confirmMood,
              icon: const Icon(Icons.mood),
              label: const Text('Salvar'),
            ),
            const SizedBox(height: 24),
            const Text('Histórico de humor:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: _historico.isEmpty
                  ? const Text('Nenhum humor registrado ainda.')
                  : ListView.builder(
                      itemCount: _historico.length,
                      itemBuilder: (context, index) {
                        final item = _historico[index];
                        final imageUrl = item['imageUrl'];
                        final emoji = item['emoji'] ?? '';
                        final timestamp = item['timestamp']?.toString().substring(0, 16) ?? '';
                        final id = item['id'];
                        final mensagem = item['mensagem'] ?? '';

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Text(emoji, style: const TextStyle(fontSize: 24)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(mensagem),
                                  Text(timestamp, style: const TextStyle(fontSize: 12, color: AppColors.textDark)),
                                  if (imageUrl != null) SizedBox(height: 60, width: 60, child: Image.network(imageUrl)),
                                ],
                              ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete, color:  AppColors.primary),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Confirmar exclusão'),
                                        content: const Text('Deseja excluir este humor?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text('Excluir'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true && id != null) {
                                      await DatabaseService().deleteMoodFromHistory(id);
                                      _carregarHistorico(); // Atualiza lista após excluir
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: AppColors.primary),
                                  onPressed: () async {
                                    final controller = TextEditingController(text: mensagem);

                                    final novaMensagem = await showDialog<String>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Editar mensagem'),
                                        content: TextField(
                                          controller: controller,
                                          decoration: const InputDecoration(hintText: 'Nova mensagem'),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, controller.text.trim()),
                                            child: const Text('Salvar'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (novaMensagem != null && novaMensagem.isNotEmpty) {
                                      await DatabaseService().updateMoodMessage(id, novaMensagem);
                                      _carregarHistorico();
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.camera_alt, color: AppColors.primary),
                                  onPressed: () async {
                                    final img = await ImagePicker().pickImage(source: ImageSource.camera);
                                    if (img != null) setState(() => _pickedImage = img);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
