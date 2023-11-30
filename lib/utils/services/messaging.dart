import 'package:projeto_chat/utils/model/Message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messaging {
  CollectionReference chat = FirebaseFirestore.instance.collection('chat');
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  setMessage(String content, String sender, String id) async {
    var messages = await getMessage(id);
    messages.add({"content": content, "sender": sender});
    final snapshots =
        await chat.where("id", isEqualTo: id).get().then((value) => value);
    var docId = snapshots.docs.map((e) => e.get("docId")).single;
    chat
        .doc(docId)
        .update({"messages": messages});
  }

  Future<List<dynamic>> getMessage(String id) async {
    var messages;
    final snapshots =
        await chat.where("id", isEqualTo: id).get().then((value) => value);
    messages = snapshots.docs.map((e) => e.get("messages")).toList();
    return messages[0];
  }
}
