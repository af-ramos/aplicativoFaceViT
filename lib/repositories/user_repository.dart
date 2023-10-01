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

  Future<List<List<dynamic>>> getUsers() async {
    try {
      final snapshot = await db.collection('usuarios').get();

      final usuarios = await Future.wait(snapshot.docs.map((user) async {
        return [
          user['nome'],
          await st.ref().child("${user.id}.png").getDownloadURL()
        ];
      }).toList());

      return usuarios;
    } on FirebaseException catch (e) {
      throw FirebaseException(
          plugin: e.toString()); // ! VERIFICAR OS CASOS DE ERRO
    }
  }

  Future<double> compareUser(String userID, File imagem) async {
    return 1.0;
  }

  void addUser(UserModel user, File imagem) async {
    try {
      final request = http.MultipartRequest(
          'POST', Uri.parse('${Connection.ngrokUrl}/extractFeatures'));

      request.files
          .add(await http.MultipartFile.fromPath('imagem', imagem.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        user.features =
            json.decode(await response.stream.bytesToString())['features'];

        db
            .collection('usuarios')
            .withConverter(
                fromFirestore: UserModel.fromFirestore,
                toFirestore: (UserModel user, options) => user.toFirestore())
            .doc(user.id)
            .set(user);

        st.ref().child('${user.id}.png').putFile(imagem);
      } else {
        debugPrint('ERRO :('); // ! VERIFICAR OS CASOS DE ERRO
      }
    } on FirebaseException catch (e) {
      throw FirebaseException(
          plugin: e.toString()); // ! VERIFICAR OS CASOS DE ERRO
    }
  }
}
