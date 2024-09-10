import 'dart:io';

import 'package:brtoon/common_widgets/anuncios_widget.dart';
import 'package:brtoon/common_widgets/build_text_field.dart';
import 'package:brtoon/common_widgets/showOrderConfirmation_widgest.dart';
import 'package:brtoon/publications/controller/publish_cape_history.dart';
import 'package:brtoon/util_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PublishCapeHistoryTab extends StatefulWidget {
  static const String routeName = '/publish-cape';
  const PublishCapeHistoryTab({Key? key}) : super(key: key);

  @override
  State<PublishCapeHistoryTab> createState() => _PublishCapeHistoryTabState();
}

class _PublishCapeHistoryTabState extends State<PublishCapeHistoryTab> {
  final imagePicker = ImagePicker();
  final UtilsServices utilsServices = UtilsServices();
  XFile? capa;

  final publishCapeHistoryController = Get.find<PublishCapeHistoryController>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Adiar a inicialização até que o widget esteja completamente construído
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await publishCapeHistoryController.fetchAllCategories();
      if (publishCapeHistoryController.allCategories.isNotEmpty) {
        categoryController.text =
            publishCapeHistoryController.allCategories.first.id.toString();
        publishCapeHistoryController
            .selectCategory(publishCapeHistoryController.allCategories.first);
      }
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Adicionar Capa da História',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: publishCapeHistoryController.fetchAllCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Erro ao carregar categorias'));
              } else {
                return Column(
                  children: [
                    BuildTextField(
                      controller: titleController,
                      label: 'Título da História',
                      icon: PhosphorIcons.pencil,
                    ),
                    ListTile(
                      leading: const Icon(Icons.attach_file),
                      title: const Text(
                        'Capa da História',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      onTap: () => uploadImage(),
                      trailing: getImageWidget(),
                    ),
                    buildCategoryDropdown(),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 45,
                      child: Obx(() => ElevatedButton(
                            onPressed: publishCapeHistoryController
                                    .isLoading.value
                                ? null
                                : () async {
                                    FocusScope.of(context).unfocus();
                                    bool? result = await ShowOrderConfirmation
                                        .showOrderConfirmation(
                                            context,
                                            'Você tem certeza que deseja publicar esta história?',
                                            'Sim',
                                            'Não');
                                    if (result ?? false) {
                                      if (capa != null &&
                                          titleController.text.isNotEmpty &&
                                          categoryController.text.isNotEmpty) {
                                        // Chame publishHistory com o arquivo da imagem
                                        await publishCapeHistoryController
                                            .publishHistory(
                                          title: titleController.text,
                                          image: capa!, // Passe a imagem aqui
                                          category: categoryController.text,
                                        );
                                      } else {
                                        utilsServices.showToast(
                                          message:
                                              'Preencha todos os campos antes de publicar.',
                                          isError: true,
                                        );
                                      }
                                    } else {
                                      utilsServices.showToast(
                                        message: 'Publicação não concluída.',
                                      );
                                    }
                                  },
                            child: publishCapeHistoryController.isLoading.value
                                ? const CircularProgressIndicator()
                                : const Text('Publicar'),
                          )),
                    ),
                    const AnunciosWidget(
                      adUnitId: 'ca-app-pub-4426001722546287/1232629222',
                    ),
                  ],
                );
              }
            },
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

  Widget buildCategoryDropdown() {
    return GetBuilder<PublishCapeHistoryController>(
      builder: (controller) {
        if (categoryController.text.isEmpty) {
          categoryController.text = controller.allCategories.first.id;
        }

        return Container(
          padding: const EdgeInsets.only(bottom: 15),
          decoration: const BoxDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Escolha o gênero da sua estoria:',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: controller.selectedCategoryId.toString(),
                items: controller.allCategories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.id.toString(),
                    child: Text(category.title),
                  );
                }).toList(),
                onChanged: (value) {
                  String categoryId = value ?? '';
                  controller.selectCategory(
                    controller.allCategories.firstWhere(
                      (category) => category.id.toString() == categoryId,
                    ),
                  );
                  categoryController.text = categoryId;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    super.dispose();
  }
}
