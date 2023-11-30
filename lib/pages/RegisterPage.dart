import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_chat/pages/HomePage.dart';
import 'package:projeto_chat/utils/services/authentication.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final Authentication _authentication = Authentication();
  String? perfilImagePath;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController confirmaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastrar")),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formKey,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                          hintText: "Nome"),
                      controller: nomeController,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                          icon: Icon(Icons.mail),
                          border: OutlineInputBorder(),
                          hintText: "Email"),
                      controller: emailController,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.password),
                          border: OutlineInputBorder(),
                          hintText: "Senha"),
                      controller: senhaController,
                      validator: (value) {
                        if (senhaController.text.isEmpty ||
                            senhaController.text == "") {
                          return "A senha não pode ser nula";
                        }
                        if (senhaController.text.length < 6) {
                          return "A senha deve possui ao menos 6 caracteres";
                        }
                        if (!senhaController.text.contains(RegExp('[A-Z]'))) {
                          return "A senha deve possui pelo menos uma letra maiúscula";
                        }
                        if (!senhaController.text.contains(RegExp('[a-a]'))) {
                          return "A senha deve possui pelo menos uma letra minuscula";
                        }
                        return "";
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.check),
                          border: OutlineInputBorder(),
                          hintText: "Confirme sua senha"),
                      controller: confirmaController,
                      validator: (value) {
                        if (senhaController.text != confirmaController.text) {
                          return "As senhas informadas nao coincidem";
                        }
                      },
                    ),
                  ],
                )),
          ),
          ListTile(
            leading: const Icon(Icons.attach_file),
            title: const Text("Imagem de perfil"),
            trailing: perfilImagePath != null
                ? Image.file(File(perfilImagePath!))
                : null,
            onTap: selecionaImagem,
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
              onPressed: () async {                
                await _authentication.addUser(
                    nome: nomeController.text,
                    email: emailController.text,
                    senha: senhaController.text,
                    path: perfilImagePath);
                Get.to(HomePage());
              },
              child: const Text("Enviar"))
        ],
      )),
    );
  }

  selecionaImagem() async {
    final ImagePicker picker = ImagePicker();

    try {
      XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) setState(() => perfilImagePath = file.path);
    } catch (e) {
      print(e);
    }
  }
}
