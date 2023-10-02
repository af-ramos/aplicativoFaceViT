// import 'package:camera/camera.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:face_vit/repositories/user_repository.dart';
import 'package:face_vit/telas/tela_camera.dart';
import 'package:face_vit/telas/tela_usuario.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key, this.foto, this.userID});
  final XFile? foto;
  final String? userID;

  @override
  State<TelaLogin> createState() => TelaLoginState();
}

class TelaLoginState extends State<TelaLogin> {
  final formKey = GlobalKey<FormState>();
  TextEditingController userInput = TextEditingController();

  UserRepository userRepo = UserRepository();

  late File arquivoFoto;
  bool hasPhoto = false;
  bool errorPhoto = false;

  OutlineInputBorder buttonStyle(BuildContext context, bool isError) {
    return OutlineInputBorder(
        borderSide: BorderSide(
            color: isError
                ? Theme.of(context).colorScheme.errorContainer
                : Theme.of(context).colorScheme.inversePrimary,
            width: 2.0),
        borderRadius: BorderRadius.circular(50.0));
  }

  @override
  initState() {
    super.initState();

    if (widget.foto != null) {
      arquivoFoto = File(widget.foto!.path);
      hasPhoto = true;

      userInput.text = widget.userID!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Tela de Login",
            style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onPrimaryContainer)),
        centerTitle: true,
        elevation: 5,
        shadowColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
          child: SingleChildScrollView(
              child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TelaCamera(userID: userInput.text, tela: 2)));
                },
                child: Center(
                    child: (hasPhoto)
                        ? (ClipOval(
                            child: SizedBox.fromSize(
                                size: const Size.fromRadius(50),
                                child: Image.file(
                                  arquivoFoto,
                                  fit: BoxFit.cover,
                                )),
                          ))
                        : Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: (!errorPhoto)
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .errorContainer,
                            ),
                            height: 100,
                            width: 100,
                            child: Icon(Icons.photo_camera_front_rounded,
                                color: (!errorPhoto)
                                    ? Theme.of(context)
                                        .colorScheme
                                        .inversePrimary
                                    : Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                size: 50),
                          )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: userInput,
                style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome de usuário...';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: 'Nome de Usuário',
                    labelStyle: GoogleFonts.montserrat(
                        fontSize: 15,
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                    prefixIcon: const Icon(Icons.verified_user),
                    enabledBorder: buttonStyle(context, false),
                    focusedBorder: buttonStyle(context, false),
                    errorBorder: buttonStyle(context, true),
                    focusedErrorBorder: buttonStyle(context, true)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                onPressed: () async {
                  if (hasPhoto == false) {
                    setState(() {
                      errorPhoto = true;
                    });
                  }

                  if (formKey.currentState!.validate() && !errorPhoto) {
                    final similarity =
                        await userRepo.compareUser(userInput.text, arquivoFoto);

                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('A similaridade é de: $similarity :o'),
                        duration: const Duration(seconds: 2)));

                    if (similarity >= 0.4) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TelaUsuario(userID: userInput.text)));
                    }
                  }
                },
                child: Text("ENTRAR",
                    style: GoogleFonts.montserrat(
                        fontSize: 15,
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer)),
              ),
            ),
          ],
        ),
      ))),
    );
  }
}
