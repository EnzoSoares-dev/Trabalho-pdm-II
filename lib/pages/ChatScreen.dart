import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projeto_chat/utils/model/user.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:projeto_chat/utils/services/chatting.dart';
import 'package:projeto_chat/widgets/UserItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  String content = "";
  

  // final userData = [
  //   UserModel(
  //       uid: '1',
  //       email: 'email@email.com',
  //       nome: 'Elizabeth',
  //       senha: 'senha123',
  //       fotoPerfil: 'https://i.pravatar.cc/150?img=0'),
  //   UserModel(
  //       uid: '2',
  //       email: 'email@email.com',
  //       nome: 'Johan',
  //       senha: 'senha123',
  //       fotoPerfil: 'https://i.pravatar.cc/150?img=1'),
  //   UserModel(
  //       uid: '3',
  //       email: 'email@email.com',
  //       nome: 'Noah',
  //       senha: 'senha123',
  //       fotoPerfil: 'https://i.pravatar.cc/150?img=2'),
  //   UserModel(
  //       uid: '4',
  //       email: 'email@email.com',
  //       nome: 'Mary',
  //       senha: 'senha123',
  //       fotoPerfil: 'https://i.pravatar.cc/150?img=3')
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conversas"),
      ),
      body: FutureBuilder(
          future: Chatting().findChats(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: snapshot.data.length,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                itemBuilder: (context, index) =>
                    UserItem(user: snapshot.data[index],docId:index),
                physics: const BouncingScrollPhysics(),
              );
            }
            return const Center(
              child: Text("Você não possui conversas ativas."),
            );
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            escaneiaQrCode();
          },
          child: const Icon(Icons.add)),
    );
  }

  escaneiaQrCode() async {
    try {
      String user = await FlutterBarcodeScanner.scanBarcode(
          "#FFFF0000", "Cancelar", false, ScanMode.QR);
      setState(() => content = user != "-1" ? user : "{}");
    } catch (e) {
      print("Erro na leitura do código $e");
      Get.snackbar("Erro", "Erro na leitura do código");
    }
    final obj = jsonDecode(content);
    if (obj["real"] == true) {
      Chatting().addChat(obj["uid"],obj["nome"],obj["fotoPerfil"]);
    } else {
      Get.snackbar("Erro", "Erro na leitura do código");
    }
  }
}
