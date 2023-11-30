import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_chat/pages/ChatPage.dart';
import 'package:projeto_chat/utils/model/chat.dart';

class UserItem extends StatefulWidget {
  const UserItem({super.key, required this.user, required this.docId});

  final ChatModel user;
  final int docId;

  UserItemState createState() => UserItemState();
}

class UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.to(ChatPage(fotoPerfil: widget.user.foto, name: widget.user.nome,docId: widget.docId, id:widget.user.id));
      },
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(widget.user.foto),
      ),
      title: Text(widget.user.nome),
    );
  }
}
