class UserModel {
  final String? uid;
  final String nome;
  final String? email;
  final String? senha;
  final String fotoPerfil;

  const UserModel(
      {this.uid,
      this.email,
      required this.nome,
      this.senha,
      required this.fotoPerfil});

  toJson() {
    return {
      "nome": nome,
      "email": email,
      "senha": senha,
      "fotoPerfil": fotoPerfil
    };
  }
}
