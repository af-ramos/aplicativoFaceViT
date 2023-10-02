import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaInformacoes extends StatefulWidget {
  const TelaInformacoes({super.key, required this.informationImage});
  final Image informationImage;

  @override
  State<TelaInformacoes> createState() => TelaInformacoesState();
}

class TelaInformacoesState extends State<TelaInformacoes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Tela de Informações",
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
        children: [
          Image(image: widget.informationImage.image, width: 300),
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
            child: Text(
                'O aplicativo busca aplicar o modelo de Vision Transformer no reconhecimento facial, através da comparação das imagens tiradas na hora do login com as do cadastro, já armazenadas no banco de dados :D',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onPrimaryContainer)),
          )
        ],
      )),
    );
  }
}
