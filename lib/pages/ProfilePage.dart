import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_chat/pages/LoginPage.dart';
import 'package:projeto_chat/utils/model/user.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<UserModel> user;

  void logout() {
    _prefs.then((value) => value.clear());
    Get.offAll(() => const LoginPage());
  }

  @override
  void initState() {
    user = _prefs.then((SharedPreferences prefs) {
      return UserModel(
          uid: prefs.getString('id'),
          email: prefs.getString("email")!,
          nome: prefs.getString("nome")!,
          fotoPerfil: prefs.getString("fotoPerfil")!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Perfil de usuário"),
          actions: <Widget>[
            IconButton(onPressed: logout, icon: const Icon(Icons.exit_to_app))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder(
              future: user,
              builder:
                  (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
                if (snapshot.hasData) {
                  return Center(
                      child: Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      CircleAvatar(
                        radius: 75,
                        backgroundImage:
                            NetworkImage(snapshot.data!.fotoPerfil),
                        backgroundColor: Colors.blue,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        snapshot.data!.nome,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text("Converse comigo!"),
                      const SizedBox(
                        height: 10,
                      ),
                      QrImageView(
                        data: '{"uid":"${snapshot.data!.uid!}","nome":"${snapshot.data!.nome}","fotoPerfil":"${snapshot.data!.fotoPerfil}","real":true}',
                        size: 145,
                        gapless: true,
                        version: QrVersions.auto,
                        errorCorrectionLevel: QrErrorCorrectLevel.Q,
                      ),
                    ],
                  ));
                }
                return Center(
                    child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.yellow,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      "usuario",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Converse comigo!"),
                    const SizedBox(
                      height: 10,
                    ),
                    QrImageView(
                      data: "",
                      size: 145,
                      gapless: true,
                      version: QrVersions.auto,
                      errorCorrectionLevel: QrErrorCorrectLevel.Q,
                    ),
                  ],
                ));
              }),
        ));
  }
}
