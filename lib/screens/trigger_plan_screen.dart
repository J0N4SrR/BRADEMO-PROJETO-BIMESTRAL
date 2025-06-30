import 'package:flutter/material.dart';
import 'package:projeto_bimestral/services/database_service.dart';
import 'package:projeto_bimestral/theme/app_colors.dart';

class TriggerPlanScreen extends StatefulWidget {
  const TriggerPlanScreen({super.key});

  @override
  State<TriggerPlanScreen> createState() => _TriggerPlanScreenState();
}

class _TriggerPlanScreenState extends State<TriggerPlanScreen> {
  List<Map<String, dynamic>> _plans = [];

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    final plans = await DatabaseService().getTriggerPlans();
    setState(() {
      _plans = plans;
    });
  }

  void _addPlan() async {
    final titleController = TextEditingController();
    final stepsController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Novo plano de gatilho'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Título')),
            TextField(controller: stepsController, decoration: const InputDecoration(labelText: 'Passos (separados por vírgula)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final stepsRaw = stepsController.text.trim();

              if (title.isNotEmpty && stepsRaw.isNotEmpty) {
                final steps = stepsRaw.split(',').map((s) => {'title': s.trim(), 'done': false}).toList();
                await DatabaseService().createTriggerPlan(title, steps);
                await _loadPlans();
                Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _toggleStep(String planId, int index, bool value) async {
    final plan = _plans.firstWhere((p) => p['id'] == planId);
    final rawSteps = plan['steps'];
    final steps = rawSteps is List
        ? rawSteps.map((s) => Map<String, dynamic>.from(s as Map)).toList(): [];
    steps[index]['done'] = value;
    await DatabaseService().updateTriggerPlan(planId, {'steps': steps});
    await _loadPlans();
  }

  void _deletePlan(String id) async {
    await DatabaseService().deleteTriggerPlan(id);
    await _loadPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planos de Gatilho')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPlan,
        child: const Icon(Icons.add),
      ),
      body: _plans.isEmpty
          ? const Center(child: Text('Nenhum plano criado.'))
          : ListView.builder(
              itemCount: _plans.length,
              itemBuilder: (context, index) {
                final plan = _plans[index];
                final rawSteps = plan['steps'];
                final steps = rawSteps is List
                  ? rawSteps.map((s) => Map<String, dynamic>.from(s as Map)).toList(): [];
                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ExpansionTile(
                    title: Text(plan['title'] ?? ''),
                    children: [
                      ...steps.asMap().entries.map((entry) {
                        final i = entry.key;
                        final step = entry.value;
                        return CheckboxListTile(
                          title: Text(step['title']),
                          value: step['done'],
                          onChanged: (val) {
                            _toggleStep(plan['id'], i, val ?? false);
                          },
                        );
                      }),
                      ButtonBar(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete, color: AppColors.primary),
                            onPressed: () => _deletePlan(plan['id']),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
