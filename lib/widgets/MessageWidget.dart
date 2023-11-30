import 'package:flutter/material.dart';
import 'package:projeto_chat/utils/model/Message.dart';

class MessageWidget extends StatelessWidget {
  final Message mensagem;
  final String chatFriend;
  const MessageWidget({super.key, required this.mensagem,required this.chatFriend});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: posicionaMensagem(),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: coloreMensagem(),
            ),
            margin: const EdgeInsets.all(5),
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  Text(
                    mensagem.sender,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    textAlign: alinhaSender(),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    mensagem.content,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            )));
  }

  Alignment posicionaMensagem() {
    if (mensagem.sender == chatFriend) {
      return Alignment.topLeft;
    }
    return Alignment.topRight;
  }

  Color coloreMensagem() {
    if (mensagem.sender != chatFriend) {
      return Colors.blue.shade200;
    }
    return Colors.grey.shade200;
  }

  TextAlign alinhaSender() {
    if (mensagem.sender == chatFriend) {
      return TextAlign.right;
    }
    return TextAlign.right;
  }
}
