import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_chat/utils/services/messaging.dart';
import 'package:projeto_chat/widgets/MessageWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/model/Message.dart';

class ChatPage extends StatefulWidget {
  final String name;
  final String fotoPerfil;
  final int docId;
  final String id;
  const ChatPage(
      {super.key,
      required this.name,
      required this.fotoPerfil,
      required this.id,
      required this.docId});

  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  Messaging messaging = Messaging();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _chatStream = FirebaseFirestore.instance
        .collection('chat')
        //.where("id", isEqualTo: widget.id)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
          title: Row(children: [
        CircleAvatar(
            radius: 20, backgroundImage: NetworkImage(widget.fotoPerfil)),
        const SizedBox(
          width: 10,
        ),
        Text(widget.name)
      ])),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
              stream: _chatStream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Algo de errado ocorreu"));
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("Inicie uma conversa"),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data!.docs[widget.docId].get("messages").length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data!.docs[0];
                      print("teste ${ds.get("messages")}");
                      Message mensagem = Message(
                          content: ds.get("messages")[index]["content"],
                          sender: ds.get("messages")[index]["sender"]);
                      return Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: MessageWidget(
                            mensagem: mensagem,
                            chatFriend: widget.name,
                          ),
                        ),
                      );
                    });
              }),
          // FutureBuilder(
          //     future: getMessage(widget.id),
          //     builder: (BuildContext context, AsyncSnapshot snapshot) {
          //       if (snapshot.hasData) {
          //         return ListView.builder(
          //             itemCount: snapshot.data.length,
          //             shrinkWrap: true,
          //             physics: const NeverScrollableScrollPhysics(),
          //             padding: const EdgeInsets.only(top: 10, bottom: 10),
          //             itemBuilder: (context, index) {
          //               Message mensagem = Message(
          //                   content: snapshot.data![index]["content"],
          //                   sender: snapshot.data![index]["sender"]);
          //               return Container(
          //                 padding: const EdgeInsets.only(top: 10, bottom: 10),
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(left: 0),
          //                   child: MessageWidget(
          //                     mensagem: mensagem,
          //                     chatFriend: widget.name,
          //                   ),
          //                 ),
          //               );
          //             });
          //       }
          //       return Center(child: Text("Inicie a conversa"));
          //     }),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                          hintText: "Escreva algo...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                      controller: messageController,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      setMessage(messageController.text, widget.docId);
                      messageController.text = "";
                    },
                    backgroundColor: Colors.blue,
                    elevation: 0,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  setMessage(String content, int docid) async {
    var prefs = await _prefs;
    messaging.setMessage(content, prefs.getString("nome")!, widget.id);
  }

  snapshotDocId() async {
    var prefs = await _prefs;
    return FirebaseFirestore.instance
        .collection("chat")
        .doc(prefs.getStringList("docsId")![widget.docId])
        .snapshots();
  }

  getMessage(String id) async {
    print("mensagens ${await messaging.getMessage(id)}");
    return await messaging.getMessage(id);
  }
}

List<Message> mensagens = [
  Message(content: "Boa tarde", sender: "Fulano"),
  Message(content: "content", sender: "Clicrano")
];
