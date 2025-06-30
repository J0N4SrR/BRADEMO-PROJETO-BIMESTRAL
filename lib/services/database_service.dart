import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  // Cria
  Future<void> createUserData(String uid, Map<String, dynamic> data) async {
  await _firebaseDatabase.ref('users/$uid').set(data);
  }


  // Criar uma positive note
  Future<void> createUnique({required String path, required Map<String, dynamic> data}) async {
    final ref = _firebaseDatabase.ref(path).push();
    await ref.set(data);
  }

  // Ler uma positive note
  Future<List<Map<String, dynamic>>> readList({required String path}) async {
    final snapshot = await _firebaseDatabase.ref(path).get();

    if (snapshot.exists && snapshot.value != null) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return data.entries.map((e) {
        return {
          'id': e.key,
          ...Map<String, dynamic>.from(e.value),
        };
      }).toList();
    }
    return [];
  }

  // Edita uma positive note
  Future<void> updatePositiveNote(String id, Map<String, dynamic> data) async {
    await _firebaseDatabase.ref('positive_notes/$id').update(data);
  }

  // Exclui uma positive note
  Future<void> deletePositiveNote(String id) async {
    await _firebaseDatabase.ref('positive_notes/$id').remove();
  }


    // Criar plano
  Future<void> createTriggerPlan(String title, List<Map<String, dynamic>> steps) async {
    final ref = _firebaseDatabase.ref('trigger_plans').push();
    await ref.set({
      'title': title,
      'steps': steps, // já é uma lista, NÃO converta pra map
    });
  }


  // Ler todos os planos
  Future<List<Map<String, dynamic>>> getTriggerPlans() async {
    final ref = _firebaseDatabase.ref('trigger_plans');
    final snapshot = await ref.get();

    if (snapshot.exists && snapshot.value != null) {
      final raw = Map<String, dynamic>.from(snapshot.value as Map);
      return raw.entries.map((e) {
        final plan = Map<String, dynamic>.from(e.value);
        plan['id'] = e.key;
        return plan;
      }).toList();
    }

    return [];
  }

  // Atualizar passos ou título
  Future<void> updateTriggerPlan(String id, Map<String, dynamic> data) async {
    final ref = _firebaseDatabase.ref('trigger_plans/$id');
    await ref.update(data);
  }

  // Deletar plano
  Future<void> deleteTriggerPlan(String id) async {
    final ref = _firebaseDatabase.ref('trigger_plans/$id');
    await ref.remove();
  }

  // Salvar emoji
  Future<void> saveMoodEmoji(String emoji) async {
    final ref = _firebaseDatabase.ref('mood/atual');
    await ref.set({'emoji': emoji});
  }

  // ler emoji salvo
  Future<String?> getSavedMoodEmoji() async {
    final ref = _firebaseDatabase.ref('mood/atual');
    final snapshot = await ref.get();

    if (snapshot.exists && snapshot.value != null) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return data['emoji'] as String?;
    }

    return null;
  }

  // Salva os emojis escolhidos numa lista
  Future<void> saveMoodToHistory(String emoji, String mensagem) async {
    final ref = _firebaseDatabase.ref('mood/historico').push();
    await ref.set({
      'emoji': emoji,
      'mensagem': mensagem,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // Edita a mensagem salva junto com o emoji
  Future<void> updateMoodMessage(String id, String novaMensagem) async {
    final ref = _firebaseDatabase.ref('mood/historico/$id');
    await ref.update({'mensagem': novaMensagem});
  }

  // Lê a lista de emojis salvos
  Future<List<Map<String, dynamic>>> getMoodHistory() async {
  final ref = _firebaseDatabase.ref('mood/historico');
  final snapshot = await ref.get();

  if (snapshot.exists && snapshot.value != null) {
    final rawData = snapshot.value as Map;
    final list = rawData.entries.map((entry) {
      final data = Map<String, dynamic>.from(entry.value);
      data['id'] = entry.key; // útil para excluir depois, se quiser
      return data;
    }).toList();

    // Ordena do mais recente pro mais antigo
    list.sort((a, b) => (b['timestamp'] ?? '').compareTo(a['timestamp'] ?? ''));
    return list;
  }

  return [];
}

  // Deleta algum emoji salvo
  Future<void> deleteMoodFromHistory(String id) async {
    final ref = _firebaseDatabase.ref('mood/historico/$id');
    await ref.remove();
  }


  // Create (update)
  Future<void> create({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final ref = _firebaseDatabase.ref(path).push(); // ou .child(path) se quiser sobrescrever
    await ref.set(data);
  }

  // // Read
  Future<List<Map<String, dynamic>>> read(String path) async {
  final ref = _firebaseDatabase.ref(path);
  final snapshot = await ref.get();

  if (snapshot.exists && snapshot.value != null) {
    final rawData = snapshot.value as Map;
    final messages = rawData.entries.map((entry) {
      final data = Map<String, dynamic>.from(entry.value as Map);
      data['id'] = entry.key; // <-- adiciona o ID da mensagem
      return data;
    }).toList();
    return messages;
    } else {
    return [];
    }
  }

  // Update
  Future<void> update({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final DatabaseReference ref = _firebaseDatabase.ref().child(path);
    await ref.update(data);
  }

  // Delete
  Future<void> delete({required String path}) async {
  final DatabaseReference ref = _firebaseDatabase.ref().child(path);
  await ref.remove();

  
}

}