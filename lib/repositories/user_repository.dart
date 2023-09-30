import 'dart:convert';
import 'dart:io';
import 'package:face_vit/connection.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_vit/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final db = FirebaseFirestore.instance;
  final st = FirebaseStorage.instance;

  Future<List<List<String>>> getUsers() async {
    try {
      final snapshot = await db.collection('usuarios').get();
      final users = snapshot.docs
          .map((user) => UserModel.fromFirestore(user, null))
          .toList();

      List<List<String>> usuarios = [];

      for (var user in users) {
        usuarios.add([
          user.nome,
          await st.ref().child('${user.id}.png').getDownloadURL()
        ]);
      }

      return usuarios;
    } on FirebaseException catch (e) {
      throw FirebaseException(
          plugin: e.toString()); // ! VERIFICAR OS CASOS DE ERRO
    }
  }

  void addUser(UserModel user, File imagem) async {
    try {
      final imageRef = st.ref().child('${user.id}.png');

      await imageRef.putFile(imagem).then((_) {
        imageRef.getDownloadURL().then((imageUrl) async {
          final response = await http.post(Uri.parse(Connection.ngrokUrl),
              body: jsonEncode({'imageUrl': imageUrl}));

          if (response.statusCode == 200) {
            final featuresJson =
                jsonDecode(response.body) as Map<String, dynamic>;

            user.features = featuresJson.values.toList()[0];

            db
                .collection('usuarios')
                .withConverter(
                    fromFirestore: UserModel.fromFirestore,
                    toFirestore: (UserModel user, options) =>
                        user.toFirestore())
                .doc(user.id)
                .set(user);
          } else {
            debugPrint("ERRO"); // ! VERIFICAR OS CASOS DE ERRO / LANÇAR UMA EXCEPTION
          }
        });
      });
    } on FirebaseException catch (e) {
      throw FirebaseException(
          plugin: e.toString()); // ! VERIFICAR OS CASOS DE ERRO
    }
  }
}
