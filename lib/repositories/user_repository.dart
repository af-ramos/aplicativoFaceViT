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

  Future getUserData(String userID) async {
    final user = await db
        .collection('usuarios')
        .doc(userID)
        .withConverter(
            fromFirestore: UserModel.fromFirestore,
            toFirestore: (UserModel user, _) => user.toFirestore())
        .get();

    final imageUrl = await st.ref().child('$userID.png').getDownloadURL();

    return [user.data()!, imageUrl];
  }

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

  Future<double> verifyUser(String userID, File imagem) async {
    try {
      final request = http.MultipartRequest(
          'POST', Uri.parse('${Connection.ngrokUrl}/verifyUser'));

      final userData = await db.collection('usuarios').doc(userID).get();
      final userFeatures = userData.data()?['features'];

      request.files
          .add(await http.MultipartFile.fromPath('imagem', imagem.path));
      request.fields.addAll({'features': jsonEncode(userFeatures)});

      final response = await request.send();

      if (response.statusCode == 200) {
        return json.decode(await response.stream.bytesToString())['similarity'];
      } else {
        debugPrint('ERRO :('); // ! VERIFICAR OS CASOS DE ERRO
        return -1;
      }
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: e.toString());
    }
  }

  Future<dynamic> identifyUser(File imagem) async {
    try {
      final request = http.MultipartRequest(
          'POST', Uri.parse('${Connection.ngrokUrl}/identifyUser'));

      final snapshot = await db.collection('usuarios').get();
      final usersFeatures = await Future.wait(snapshot.docs.map((user) async {
        return {'id': user.id, 'features': user['features']};
      }).toList());

      request.files
          .add(await http.MultipartFile.fromPath('imagem', imagem.path));
      request.fields['usersFeatures'] = jsonEncode(usersFeatures);

      final response = await request.send();

      if (response.statusCode == 200) {
        final result = json.decode(await response.stream.bytesToString());
        return ([result['userID'], result['similarity']]);
      }
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: e.toString());
    }
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

        // ! VERIFICAR SE HOUVE UPLOAD DA IMAGEM
        // ! VERIFICAR SE O CADASTRO DEU CERTO
        // ! CASO CONTRÁRIO NÃO CADASTRAR OU APAGAR IMAGEM

        st.ref().child('${user.id}.png').putFile(imagem);

        db
            .collection('usuarios')
            .withConverter(
                fromFirestore: UserModel.fromFirestore,
                toFirestore: (UserModel user, options) => user.toFirestore())
            .doc(user.id)
            .set(user);
      } else {
        debugPrint('ERRO :('); // ! VERIFICAR OS CASOS DE ERRO
      }
    } on FirebaseException catch (e) {
      throw FirebaseException(
          plugin: e.toString()); // ! VERIFICAR OS CASOS DE ERRO
    }
  }
}
