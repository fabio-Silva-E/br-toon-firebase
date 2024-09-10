import 'dart:io';

import 'package:brtoon/common_widgets/anuncios_widget.dart';
import 'package:brtoon/common_widgets/custom_text_field.dart';
import 'package:brtoon/firebase_auth/firebase_auth_service.dart';
import 'package:brtoon/util_services.dart';
import 'package:brtoon/validators/validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  RxBool isLoading = false.obs;
  final utilsServices = UtilsServices();
  final FirebaseAuthService authService = FirebaseAuthService();
  final imagePicker = ImagePicker();
  XFile? imageFile;

  // Função para buscar a URL da imagem do perfil do usuário e o e-mail
  Future<Map<String, String?>> _getUserProfile() async {
    final userId = await FirebaseAuthService.getUserId();
    String? profilePictureUrl;
    String? userEmail;
    String? userName;

    if (userId != null) {
      try {
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_pictures')
            .child(userId);
        profilePictureUrl = await ref.getDownloadURL();
        print('foto de perfil $profilePictureUrl.png');
      } catch (e) {
        print('Erro ao buscar a URL da foto de perfil: $e');
      }
    }

    try {
      userEmail = await FirebaseAuthService.getUserEmail();
    } catch (e) {
      print('Erro ao buscar o e-mail do usuário: $e');
    }
    try {
      userName = await FirebaseAuthService.getUserName();
    } catch (e) {
      print('Erro ao buscar nome do usuário: $e');
    }

    return {
      'profilePicture': profilePictureUrl,
      'email': userEmail,
      'name': userName,
    };
  }

  // Função para atualizar a foto de perfil
  Future<void> _updateProfilePicture() async {
    isLoading.value = true;
    final userId = await FirebaseAuthService.getUserId();
    if (userId == null || imageFile == null) return;

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child(userId);
      if (kIsWeb) {
        // Para web
        await ref.putData(await imageFile!.readAsBytes());
      } else {
        // Para Android/iOS
        await ref.putFile(File(imageFile!.path));
      }
      setState(() {});
    } catch (e) {
      print('Erro ao atualizar a foto de perfil: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Perfil do usuário',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<Map<String, String?>>(
        future: _getUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Nenhum dado encontrado'));
          }
          // final profilePictureUrl = snapshot.data?['photo'];
          final profilePictureUrl = snapshot.data?['profilePicture'];
          final userEmail = snapshot.data?['email'];
          final userName = snapshot.data?['name'];
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
            children: [
              // Foto de perfil
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.blueGrey,
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: imageFile != null
                              ? (kIsWeb
                                  ? NetworkImage(imageFile!.path)
                                      as ImageProvider<Object> // Web
                                  : FileImage(File(
                                      imageFile!.path))) // Mobile (Android/iOS)
                              : (profilePictureUrl != null
                                  ? NetworkImage(profilePictureUrl)
                                  : null),
                          child: imageFile == null && profilePictureUrl == null
                              ? Icon(Icons.person,
                                  size: 65, color: Colors.grey[700])
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          child: IconButton(
                            onPressed: _showOpcoesBottomSheet,
                            icon: Icon(
                              PhosphorIcons.pencil,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Botão de atualizar foto
              SizedBox(
                height: 45,
                child: Obx(() => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: isLoading.value
                          ? null
                          : () async {
                              await _updateProfilePicture();
                            },
                      child: isLoading.value
                          ? const CircularProgressIndicator()
                          : const Text('Atualizar foto'),
                    )),
              ),
              const SizedBox(height: 10),
              // Email
              CustomTextField(
                readeOnly: true,
                initialValue: userName,
                icon: Icons.person,
                label: 'Nome',
              ),
              SizedBox(
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.green,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    updateName(userName ?? '');
                  },
                  child: const Text('Editar'),
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                readeOnly: true,
                initialValue: userEmail,
                icon: Icons.email,
                label: 'Email',
              ),
              // Botão de atualizar senha
              SizedBox(
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.green,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    updatePassword();
                  },
                  child: const Text('Atualizar senha'),
                ),
              ),
              const AnunciosWidget(
                adUnitId: 'ca-app-pub-4426001722546287/9726196914',
              ),
            ],
          );
        },
      ),
    );
  }

  Future<bool?> updatePassword() {
    final newPasswordController = TextEditingController();
    final currentPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //titulo
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Atulização de senha',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        //senha atual
                        CustomTextField(
                          controller: currentPasswordController,
                          isSecret: true,
                          icon: Icons.lock,
                          label: ' Senha atual',
                          validator: passowrdValidator,
                        ),
                        //nova senha
                        CustomTextField(
                          controller: newPasswordController,
                          isSecret: true,
                          icon: Icons.lock,
                          label: 'Nova senha',
                          validator: passowrdValidator,
                        ),
                        //comfirmar senha
                        CustomTextField(
                          isSecret: true,
                          icon: Icons.lock,
                          label: 'Comfirmar nova senha',
                          validator: (password) {
                            final result = passowrdValidator(password);
                            if (result != null) {
                              return result;
                            }
                            if (password != newPasswordController.text) {
                              utilsServices.showToast(
                                message: ' As senhas não são equivalentes',
                                isError: true,
                              );
                            }
                            return null;
                          },
                        ),
                        //botão de comfirmação
                        SizedBox(
                          height: 45,
                          child: Obx(() => ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: isLoading.value
                                    ? null
                                    : () async {
                                        if (formKey.currentState!.validate()) {
                                          isLoading.value = true;
                                          try {
                                            await authService
                                                .updateUserPassword(
                                              currentPassword:
                                                  currentPasswordController
                                                      .text,
                                              newPassword:
                                                  newPasswordController.text,
                                            );
                                            Navigator.of(context).pop(true);
                                          } finally {
                                            isLoading.value = false;
                                          }
                                        }
                                      },
                                child: isLoading.value
                                    ? const CircularProgressIndicator()
                                    : const Text('Atualizar'),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: 5,
                    right: 5,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    ))
              ],
            ),
          );
        });
  }

  Future<bool?> updateName(String currentName) {
    final newNameController = TextEditingController(
        text: currentName); // Preenche o campo com o nome atual
    final currentPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Título
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Atualização de nome de perfil',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Senha atual
                      CustomTextField(
                        controller: currentPasswordController,
                        isSecret: true,
                        icon: Icons.lock,
                        label: 'Senha atual',
                      ),
                      // Novo nome
                      CustomTextField(
                        controller: newNameController,
                        icon: PhosphorIcons.pencil,
                        label: 'Novo nome',
                      ),
                      // Botão de confirmação
                      SizedBox(
                        height: 45,
                        child: Obx(() => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: isLoading.value
                                  ? null
                                  : () async {
                                      if (formKey.currentState!.validate()) {
                                        isLoading.value = true;
                                        try {
                                          await authService.updateUserName(
                                            currentPassword:
                                                currentPasswordController.text,
                                            newName: newNameController.text,
                                          );
                                          // Atualiza a interface com o novo nome
                                          setState(() {
                                            // Faz a interface refletir o novo nome
                                          });
                                          Navigator.of(context).pop(true);
                                        } finally {
                                          isLoading.value = false;
                                        }
                                      }
                                    },
                              child: isLoading.value
                                  ? const CircularProgressIndicator()
                                  : const Text('Atualizar'),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  pick(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => imageFile = pickedFile);
    }
  }

  void _showOpcoesBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      PhosphorIcons.image,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Galeria',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Buscar imagem da galeria
                  pick(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      PhosphorIcons.camera,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Câmera',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Fazer foto da câmera
                  pick(ImageSource.camera);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      PhosphorIcons.trash,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Remover',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Tornar a foto null
                  setState(() {
                    imageFile = null;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
