// import 'package:camera/camera.dart';
import 'dart:io';
import 'package:face_vit/models/user_model.dart';
import 'package:camera/camera.dart';
import 'package:face_vit/repositories/user_repository.dart';
import 'package:face_vit/telas/tela_camera.dart';
import 'package:face_vit/telas/tela_inicial.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key, this.foto, this.user});
  final XFile? foto;
  final UserModel? user;

  @override
  State<TelaCadastro> createState() => TelaCadastroState();
}

class TelaCadastroState extends State<TelaCadastro> {
  final formKey = GlobalKey<FormState>();

  TextEditingController dateInput = TextEditingController();
  TextEditingController nameInput = TextEditingController();
  TextEditingController userInput = TextEditingController();
  TextEditingController emailInput = TextEditingController();

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

      userInput.text = widget.user!.id;
      nameInput.text = widget.user!.nome;
      emailInput.text = widget.user!.email;
      dateInput.text = widget.user!.dataNascimento;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Tela de Cadastro",
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
                  UserModel user = UserModel(
                      id: userInput.text,
                      nome: nameInput.text,
                      email: emailInput.text,
                      dataNascimento: dateInput.text);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TelaCamera(user: user)));
                },
                child: Center(
                    child: (hasPhoto)
                        ? (ClipOval(
                            child: SizedBox.fromSize(
                                size: const Size.fromRadius(50),
                                child: Image.network(
                                  arquivoFoto.path,
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
              child: TextFormField(
                controller: nameInput,
                style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome...';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: 'Nome',
                    labelStyle: GoogleFonts.montserrat(
                        fontSize: 15,
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                    prefixIcon: const Icon(Icons.person),
                    enabledBorder: buttonStyle(context, false),
                    focusedBorder: buttonStyle(context, false),
                    errorBorder: buttonStyle(context, true),
                    focusedErrorBorder: buttonStyle(context, true)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: emailInput,
                style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu e-mail...';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: 'E-mail',
                    labelStyle: GoogleFonts.montserrat(
                        fontSize: 15,
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                    prefixIcon: const Icon(Icons.email),
                    enabledBorder: buttonStyle(context, false),
                    focusedBorder: buttonStyle(context, false),
                    errorBorder: buttonStyle(context, true),
                    focusedErrorBorder: buttonStyle(context, true)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua data de nascimento...';
                  }
                  return null;
                },
                style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
                controller: dateInput,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.calendar_month_rounded),
                    labelText: 'Data de Nascimento',
                    labelStyle: GoogleFonts.montserrat(
                        fontSize: 15,
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                    enabledBorder: buttonStyle(context, false),
                    focusedBorder: buttonStyle(context, false),
                    errorBorder: buttonStyle(context, true),
                    focusedErrorBorder: buttonStyle(context, true)),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2100));
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(pickedDate);
                    setState(() {
                      dateInput.text = formattedDate;
                    });
                  }
                },
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
                    UserModel user = UserModel(
                        id: userInput.text,
                        nome: nameInput.text,
                        email: emailInput.text,
                        dataNascimento: dateInput.text);

                    userRepo.addData(user);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Usuário ${user.nome} registrado :D'),
                        duration: const Duration(seconds: 2)));

                    await Future.delayed(const Duration(seconds: 3));
                    if (!mounted) return;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TelaInicial()));
                  }
                },
                child: Text("CADASTRAR",
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
