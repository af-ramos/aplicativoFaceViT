import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String nome;
  final String dataNascimento;

  const UserModel(
      {required this.id, required this.email, required this.nome, required this.dataNascimento});

  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();

    return UserModel(
      id: snapshot.id,
      nome: data?['nome'],
      email: data?['email'],
      dataNascimento: data?['idade'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      'email': email,
      'nome': nome,
      'idade': dataNascimento,
    };
  }
}
