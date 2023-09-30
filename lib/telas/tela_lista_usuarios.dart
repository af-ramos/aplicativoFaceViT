import 'package:face_vit/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaListaUsuarios extends StatefulWidget {
  const TelaListaUsuarios({super.key});

  @override
  State<TelaListaUsuarios> createState() => TelaListaUsuarioState();
}

class TelaListaUsuarioState extends State<TelaListaUsuarios> {
  UserRepository userRepo = UserRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Lista de Usuários",
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onPrimaryContainer)),
          centerTitle: true,
          elevation: 5,
          shadowColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: FutureBuilder(
          future: userRepo.getUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Text(
                  "Erro ao trazer dados :("); // ! VERIFICAR OS CASOS DE ERRO
            } else {
              final usuarios = snapshot.data;

              return ListView.builder(
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  itemCount: usuarios!.length,
                  itemBuilder: (context, index) {
                    final usuario = usuarios[index];

                    return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            ClipOval(
                              child: ClipOval(
                                  child: Image.network(usuario[1],
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 100,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;

                                return Center(
                                    child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null),
                                ));
                              })),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(usuario[0],
                                    style: GoogleFonts.montserrat(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer)))
                          ],
                        ));
                  });
            }
          },
        ));
  }
}
