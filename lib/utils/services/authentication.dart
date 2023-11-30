import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> addUser(
      {required String nome,
      required String email,
      required String senha,
      required String? path}) async {
    TaskSnapshot upload = await _registerProfileImage(path);
    final String id = Random().nextInt(2147483647).toString();
    return users
        .add({
          'id': id,
          'nome': nome,
          'email': email,
          'senha': senha,
          'imagem': await upload.ref.getDownloadURL()
        })
        .then((value) => _localStorage(id, users))
        .then((value) => print("Usuário Adicionado"))
        .catchError((error) => print("Erro ao adicionar o usuário: $error"));
  }

  _registerProfileImage(String? path) async {
    File perfilImage = File(path!);
    String ref = "images/img-${DateTime.now().toString()}.jpg";
    TaskSnapshot upload = await firebaseStorage.ref(ref).putFile(perfilImage);
    return upload;
  }

  _localStorage(String id, CollectionReference<Object?> users) async {
    final snapshot = await users.where("id", isEqualTo: id).get();
    snapshot.docs.map((e) => {_setSharedPreferencesLogin(e)}).single;
  }

  _setSharedPreferencesLogin(QueryDocumentSnapshot<Object?> user) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('id', user.get('id'));
    prefs.setString('nome', user.get('nome'));
    prefs.setString('email', user.get('email'));
    prefs.setString('fotoPerfil', user.get('imagem'));
  }

  Future<bool> login(String email, String senha) async {
    bool logado = false;
    final snapshot = await users
        .where("email", isEqualTo: email)
        .where("senha", isEqualTo: senha)
        .get();
    if (snapshot.size == 1) {
      logado = true;
      snapshot.docs.map((e) => _setSharedPreferencesLogin(e)).single;
    }
    return logado;
  }

}
