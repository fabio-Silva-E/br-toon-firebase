import 'dart:io';

import 'package:brtoon/common_widgets/anuncios_widget.dart';
import 'package:brtoon/common_widgets/showOrderConfirmation_widgest.dart';
import 'package:brtoon/publications/controller/publishi_page_history.dart';
import 'package:brtoon/splash/splash_screen.dart';
import 'package:brtoon/util_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PublishPageTab extends StatefulWidget {
  final String chapterId;
  const PublishPageTab({
    super.key,
    required this.chapterId,
  });

  @override
  State<PublishPageTab> createState() => _PublishPageTabState();
}

class _PublishPageTabState extends State<PublishPageTab> {
  Widget getImageWidget() {
    if (pagina != null) {
      if (kIsWeb) {
        return Image.network(pagina!.path); // Se for web, usa Image.network
      } else {
        return Image.file(
            File(pagina!.path)); // Para outras plataformas, usa Image.file
      }
    } else {
      return const SizedBox
          .shrink(); // Se não houver imagem, retorna um Widget vazio
    }
  }

  final UtilsServices utilsServices = UtilsServices();

  XFile? pagina;
  final pageController = Get.find<PublishPageController>();

  @override
  void initState() {
    super.initState();
    pageController.setChapter(widget.chapterId);
  }

  int pageCount = 0;

  @override
  Widget build(BuildContext context) {
    print('Chapter ID recebido: ${widget.chapterId}');
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Custom AppBar
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                child: const Text(
                  'Publicar páginas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.attach_file),
                title: const Text(
                  'Página',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onTap: () => uploadImage(),
                trailing: getImageWidget(),
              ),
              SizedBox(
                height: 45,
                child: Obx(() => ElevatedButton(
                      onPressed: pageController.isLoading.value
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();
                              bool? result = await ShowOrderConfirmation
                                  .showOrderConfirmation(
                                      context,
                                      'Está certo que quer publicar esta página?',
                                      'Sim',
                                      'Não');
                              if (result ?? false) {
                                // Verificar se todos os campos obrigatórios estão preenchidos
                                if (pagina != null) {
                                  // Realizar o upload da imagem e publicar

                                  setState(() {
                                    pageCount++;
                                  });
                                  await pageController.publishPage(
                                    image: pagina!,
                                    chapterId: widget.chapterId,
                                  );
                                } else {
                                  // Mostrar mensagem de erro se algum campo estiver vazio
                                  utilsServices.showToast(
                                    message:
                                        'Preencha todos os campos antes de publicar.',
                                    isError: true,
                                  );
                                }
                              } else {
                                utilsServices.showToast(
                                  message: 'Atualização não concluída',
                                );
                              }
                            },
                      child: pageController.isLoading.value
                          ? const CircularProgressIndicator()
                          : const Text('Publicar página'),
                    )),
              ),
              TextButton(
                onPressed: () {
                  // Navegar de volta para PublishersTab
                  Get.to(() => const SplashScreen());
                },
                child: const Text('Finalizar publicação'),
              ),
              const AnunciosWidget(
                adUnitId: 'ca-app-pub-4426001722546287/1232629222',
              ),
            ],
          ),
        ),
      ),
    );
  }

  uploadImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() => pagina = file);
      }
    } catch (e) {
      print(e);
    }
  }
}
