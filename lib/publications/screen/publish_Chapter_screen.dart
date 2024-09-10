import 'dart:io';

import 'package:brtoon/common_widgets/anuncios_widget.dart';
import 'package:brtoon/common_widgets/build_text_field.dart';
import 'package:brtoon/common_widgets/showOrderConfirmation_widgest.dart';
import 'package:brtoon/publications/controller/publish_chapter_history.dart';
import 'package:brtoon/util_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PublishChapterTab extends StatefulWidget {
  final String historyId;
  const PublishChapterTab({
    super.key,
    required this.historyId,
  });

  @override
  State<PublishChapterTab> createState() => _PublishChapterTabState();
}

class _PublishChapterTabState extends State<PublishChapterTab> {
  Widget getImageWidget() {
    if (capa != null) {
      if (kIsWeb) {
        return Image.network(capa!.path); // Se for web, usa Image.network
      } else {
        return Image.file(
            File(capa!.path)); // Para outras plataformas, usa Image.file
      }
    } else {
      return const SizedBox
          .shrink(); // Se não houver imagem, retorna um Widget vazio
    }
  }

  final UtilsServices utilsServices = UtilsServices();
  XFile? capa;
  final chapterController = Get.find<PublishChapterController>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController capeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Passa o historyId para o controller
    chapterController.setHistoryId(widget.historyId);
  }

  @override
  Widget build(BuildContext context) {
    print('History ID recebido: ${widget.historyId}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Capitulo',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BuildTextField(
                controller: titleController,
                label: 'Título ',
                icon: PhosphorIcons.pencil,
              ),
              ListTile(
                leading: const Icon(Icons.attach_file),
                title: const Text(
                  ' capa',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onTap: () => uploadImage(),
                trailing: getImageWidget(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                  child: Obx(
                () => ElevatedButton(
                  onPressed: chapterController.isLoading.value
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          bool? result =
                              await ShowOrderConfirmation.showOrderConfirmation(
                                  context,
                                  'Esta certo de que quer publicar esse capitulo?',
                                  'sim',
                                  'não');
                          if (result ?? false) {
                            // Verificar se todos os campos obrigatórios estão preenchidos
                            if (capa != null &&
                                titleController.text.isNotEmpty) {
                              // Realizar o upload da capa e publicar

                              await chapterController.publishChapter(
                                title: titleController.text,
                                image: capa!,
                                historyId: widget.historyId,
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
                              message: 'Publicação não concluida',
                            );
                          }
                        },
                  child: chapterController.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('Publicar'),
                ),
              )),
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
        setState(() => capa = file);
      }
    } catch (e) {
      print(e);
    }
  }
}
