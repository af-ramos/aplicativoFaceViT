import 'package:face_vit/telas/tela_cadastro.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => TelaInicialState();
}

class TelaInicialState extends State<TelaInicial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
            ElevatedButton.icon(
              onPressed: () {
                debugPrint("ENTRAR");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              icon: Icon(
                Icons.account_circle,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              label: Text("ENTRAR",
                  style: GoogleFonts.montserrat(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onPrimaryContainer)),
            ),
            ElevatedButton.icon(
              onPressed: () {
                debugPrint("USUÁRIOS");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              icon: Icon(
                Icons.contacts,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              label: Text(
                "USUÁRIOS",
                style: GoogleFonts.montserrat(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: () {
                debugPrint("INFORMAÇÕES");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              icon: Icon(
                Icons.help,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              label: Text(
                "INFORMAÇÕES",
                style: GoogleFonts.montserrat(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TelaCadastro()));
        },
        tooltip: 'Cadastrar',
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
