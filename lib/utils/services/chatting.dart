import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_chat/utils/model/chat.dart';
import 'package:projeto_chat/utils/services/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chatting {
  CollectionReference chat = FirebaseFirestore.instance.collection('chat');
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Authentication authentication = Authentication();

  Future<void> addChat(String id, String nome, String fotoPerfil) async {
    final SharedPreferences prefs = await _prefs;
    List<String> docId = List.empty(growable: true);
    return chat
        .add({
          'id': Random().nextInt(2147483647).toString(),
          'idsUsuarios': [id, prefs.getString("id")],
          'nomes': [nome, prefs.getString('nome')],
          'fotosPerfil': [fotoPerfil, prefs.getString("fotoPerfil")],
          'messages': [],
          'docId': ""
        })
        .then((DocumentReference doc) {
          print("doc.id ${doc.id}");
          chat.doc(doc.id).update({'docId': doc.id});
        })
        .then((value) => print("Chat criado"))
        .catchError((erro) => print("Erro ao criar o chat: $erro"));
  }

  findChats() async {
    final result = List.empty(growable: true);
    final SharedPreferences prefs = await _prefs;
    String docRef = "";
    final snapshots = await chat
        .where('idsUsuarios', arrayContains: prefs.getString("id"))
        .get();
    snapshots.docs.forEach((e) {
      for (int i = 0; i < 2; i++) {
        if (e.get("nomes")[i] != prefs.getString("nome") &&
            e.get('idsUsuarios')[i] != prefs.getString("id") &&
            e.get("fotosPerfil")[i] != prefs.getString("fotoPerfil")) {
          result.add(ChatModel(
              id: e.get("id"),
              nome: e.get("nomes")[i],
              foto: e.get("fotosPerfil")[i]));
        }
      }
    });
    return result;
  }
}
