// import 'package:camera/camera.dart';
import 'package:camera/camera.dart';
import 'package:face_vit/models/user_model.dart';
import 'package:face_vit/telas/tela_cadastro.dart';
import 'package:face_vit/telas/tela_identificacao.dart';
import 'package:face_vit/telas/tela_verificacao.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaCamera extends StatefulWidget {
  const TelaCamera({super.key, required this.tela, this.user, this.userID});

  final int tela;
  final UserModel? user;
  final String? userID;

  @override
  State<TelaCamera> createState() => TelaCameraState();
}

class TelaCameraState extends State<TelaCamera> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  bool cameraReady = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  void initializeCamera() async {
    cameras = await availableCameras();
    cameraController =
        CameraController(cameras[1], ResolutionPreset.max, enableAudio: false);

    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraReady = true;
      });
    }).catchError((e) {
      debugPrint('Erro:  + ${e.toString()}'); // ! VERIFICAR OS CASOS DE ERRO
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Tela da Câmera",
            style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onPrimaryContainer)),
        centerTitle: true,
        elevation: 5,
        shadowColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: (!cameraReady)
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.inversePrimary))
          : SizedBox(
              height: double.infinity, child: CameraPreview(cameraController)),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () async {
          if (!cameraController.value.isInitialized ||
              cameraController.value.isTakingPicture) {
            return;
          }

          try {
            XFile foto = await cameraController.takePicture();

            if (!mounted) return;

            if (widget.tela == 1) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TelaCadastro(foto: foto, user: widget.user)));
            } else if (widget.tela == 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TelaVerificacao(foto: foto, userID: widget.userID)));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TelaIdentificacao(foto: foto)));
            }
          } on CameraException catch (e) {
            debugPrint(
                "Erro ao tirar foto: ${e.toString()}"); // ! VERIFICAR OS CASOS DE ERRO
            return;
          }
        },
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
