import 'package:face_vit/telas/tela_cadastro.dart';
import 'package:face_vit/telas/tela_informacoes.dart';
import 'package:face_vit/telas/tela_lista_usuarios.dart';
import 'package:face_vit/telas/tela_verificacao.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => TelaInicialState();
}

class TelaInicialState extends State<TelaInicial> {
  Image informationImage = Image.asset('assets/reconhecimentoFacial.png');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(informationImage.image, context);

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            automaticallyImplyLeading: false,
            title: Text("Tela Inicial",
                style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onPrimaryContainer)),
            centerTitle: true,
            elevation: 5,
            shadowColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TelaVerificacao()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.inversePrimary,
                    ),
                    icon: Icon(
                      Icons.account_circle,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    label: Text("ENTRAR",
                        style: GoogleFonts.montserrat(
                            fontSize: 20,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TelaListaUsuarios()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.inversePrimary,
                    ),
                    icon: Icon(
                      Icons.contacts,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    label: Text(
                      "USUÁRIOS",
                      style: GoogleFonts.montserrat(
                          fontSize: 20,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TelaInformacoes(
                                  informationImage: informationImage)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.inversePrimary,
                    ),
                    icon: Icon(
                      Icons.help,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    label: Text(
                      "INFORMAÇÕES",
                      style: GoogleFonts.montserrat(
                          fontSize: 20,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TelaCadastro()));
            },
            tooltip: 'Cadastrar',
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        onWillPop: () async {
          return false;
        });
  }
}
