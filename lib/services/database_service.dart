import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class DatabaseService {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  DatabaseReference get _userRef => _firebaseDatabase.ref('users/$_uid');

  // Criar usuário (caso precise armazenar info adicional)
  Future<void> createUserData(String uid, Map<String, dynamic> data) async {
    await _firebaseDatabase.ref('users/$uid').set(data);
  }

  // Criar Positive Note
  Future<void> createUnique({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final ref = _userRef.child(path).push();
    await ref.set(data);
  }

  // Ler lista
  Future<List<Map<String, dynamic>>> readList({required String path}) async {
    final snapshot = await _userRef.child(path).get();

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

  // Edita Positive Note
  Future<void> updatePositiveNote(String id, Map<String, dynamic> data) async {
    await _userRef.child('positive_notes/$id').update(data);
  }

  // Exclui Positive Note
  Future<void> deletePositiveNote(String id) async {
    await _userRef.child('positive_notes/$id').remove();
  }

  // Criar plano
  Future<void> createTriggerPlan(String title, List<Map<String, dynamic>> steps) async {
    final ref = _userRef.child('trigger_plans').push();
    await ref.set({
      'title': title,
      'steps': steps,
    });
  }

  // Ler planos
  Future<List<Map<String, dynamic>>> getTriggerPlans() async {
    final snapshot = await _userRef.child('trigger_plans').get();

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

  Future<void> updateTriggerPlan(String id, Map<String, dynamic> data) async {
    await _userRef.child('trigger_plans/$id').update(data);
  }

  Future<void> deleteTriggerPlan(String id) async {
    await _userRef.child('trigger_plans/$id').remove();
  }

  Future<void> saveMoodEmoji(String emoji) async {
    await _userRef.child('mood/atual').set({'emoji': emoji});
  }

  Future<String?> getSavedMoodEmoji() async {
    final snapshot = await _userRef.child('mood/atual').get();

    if (snapshot.exists && snapshot.value != null) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return data['emoji'] as String?;
    }
    return null;
  }

  Future<void> saveMoodToHistory({
    required String emoji,
    required String mensagem,
    String? imageUrl,
  }) async {
    final ref = _userRef.child('mood/historico').push();
    await ref.set({
      'emoji': emoji,
      'mensagem': mensagem,
      'timestamp': DateTime.now().toIso8601String(),
      if (imageUrl != null) 'imageUrl': imageUrl,
    });
  }

  Future<String> uploadMoodImage(String id, XFile image) async {
    final ref = _storage.ref('mood_images/$_uid/$id.jpg');
    final task = await ref.putFile(File(image.path));
    return task.ref.getDownloadURL();
  }

  Future<void> updateMoodMessage(String id, String novaMensagem) async {
    await _userRef.child('mood/historico/$id').update({'mensagem': novaMensagem});
  }

  Future<List<Map<String, dynamic>>> getMoodHistory() async {
    final snapshot = await _userRef.child('mood/historico').get();

    if (snapshot.exists && snapshot.value != null) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final list = data.entries.map((e) {
        final item = Map<String, dynamic>.from(e.value);
        item['id'] = e.key;
        return item;
      }).toList();

      list.sort((a, b) => (b['timestamp'] ?? '').compareTo(a['timestamp'] ?? ''));
      return list;
    }
    return [];
  }

  Future<void> deleteMoodFromHistory(String id) async {
    await _userRef.child('mood/historico/$id').remove();
  }

  Future<void> create({required String path, required Map<String, dynamic> data}) async {
    await _userRef.child(path).push().set(data);
  }

  Future<List<Map<String, dynamic>>> read(String path) async {
    final snapshot = await _userRef.child(path).get();

    if (snapshot.exists && snapshot.value != null) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return data.entries.map((e) {
        final item = Map<String, dynamic>.from(e.value);
        item['id'] = e.key;
        return item;
      }).toList();
    }
    return [];
  }

  Future<void> update({required String path, required Map<String, dynamic> data}) async {
    await _userRef.child(path).update(data);
  }

  Future<void> delete({required String path}) async {
    await _userRef.child(path).remove();
  }

  getLocation() {}
}
