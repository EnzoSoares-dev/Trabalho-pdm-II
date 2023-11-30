import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_chat/pages/HomePage.dart';
import 'package:projeto_chat/pages/RegisterPage.dart';
import 'package:projeto_chat/utils/services/authentication.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  Authentication authentication = Authentication();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
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
                          border: OutlineInputBorder(), hintText: "Email"),
                      controller: emailController,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: "Senha"),
                      controller: senhaController,
                    ),
                  ],
                )),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                  onPressed: () {
                    _validaLogin(emailController.text, senhaController.text);
                  },
                  child: const Text("Enviar")),
              SizedBox(width: 10),
              ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.grey)),
                  onPressed: () {
                    Get.to(const RegisterPage());
                  },
                  child: const Text("Cadastrar"))
            ],
          ),
        ],
      )),
    );
  }

  _validaLogin(String email, String senha) async {
    bool logado = await authentication.login(email, senha);
    if (logado==true) {
      Get.to(() => HomePage());
    } else {
      Get.snackbar("Error", "Dados inválidos");
    }
  }
}
