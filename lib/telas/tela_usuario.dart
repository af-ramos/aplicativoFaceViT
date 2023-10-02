import 'package:face_vit/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaUsuario extends StatefulWidget {
  const TelaUsuario({super.key, required this.userID});
  final String userID;

  @override
  State<TelaUsuario> createState() => TelaUsuarioState();
}

class TelaUsuarioState extends State<TelaUsuario> {
  UserRepository userRepo = UserRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Tela de Usuário",
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onPrimaryContainer)),
          centerTitle: true,
          elevation: 5,
          shadowColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: FutureBuilder(
            future: userRepo.getUserData(widget.userID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Erro ao trazer dados :("));
              } else {
                final usuario = snapshot.data[0];
                final usuarioImage = snapshot.data[1];

                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipOval(
                        child: ClipOval(
                            child: Image.network(usuarioImage,
                                fit: BoxFit.cover, width: 150, height: 150,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;

                          return Center(
                              child: SizedBox(
                            width: 150,
                            height: 150,
                            child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null),
                          ));
                        })),
                      ),
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(usuario.nome,
                              style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer)),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(usuario.dataNascimento,
                          style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer)),
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(usuario.email,
                              style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer)),
                        ))
                  ],
                ));
              }
            }));
  }
}
