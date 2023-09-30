import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String nome;
  final String dataNascimento;
  List<dynamic>? features;

  UserModel(
      {required this.id,
      required this.email,
      required this.nome,
      required this.dataNascimento,
      this.features});

  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();

    return UserModel(
        id: snapshot.id,
        nome: data?['nome'],
        email: data?['email'],
        dataNascimento: data?['dataNascimento'],
        features: data?['features']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'nome': nome,
      'dataNascimento': dataNascimento,
      'features': features
    };
  }
}
