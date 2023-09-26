import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_vit/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final db = FirebaseFirestore.instance;
  final st = FirebaseStorage.instance;

  Future<UserModel?> getUser(String nomeUsuario) async {
    final ref = db.collection('usuarios').doc(nomeUsuario).withConverter(
        fromFirestore: UserModel.fromFirestore,
        toFirestore: (UserModel userModel, _) => userModel.toFirestore());

    final docSnap = await ref.get();
    final user = docSnap.data();

    return user;
  }

  void addUser(UserModel user, File imagem) async {
    await st
        .ref()
        .child('${user.nome}.png')
        .putFile(imagem);

    // user.imagemUrl = urlDownload;

    await db
        .collection('usuarios')
        .withConverter(
            fromFirestore: UserModel.fromFirestore,
            toFirestore: (UserModel user, options) => user.toFirestore())
        .doc(user.id)
        .set(user);
  }
}
