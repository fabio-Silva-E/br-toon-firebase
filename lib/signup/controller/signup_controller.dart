import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class SignupController {
  final signupFormKey = GlobalKey<FormState>();

  final RxBool isLoading = false.obs;

  Future<String?> uploadProfilePicture(XFile imageFile, String userId) async {
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_pictures/$userId');
      if (kIsWeb) {
        await storageReference.putData(await imageFile.readAsBytes());
      } else {
        await storageReference.putFile(File(imageFile.path));
      }

      // Retorna a URL do arquivo carregado no Storage
      return await storageReference.getDownloadURL();
    } catch (e) {
      print('Erro ao carregar imagem de perfil: $e');
      return null;
    }
  }

  Future<void> saveUserData(
      String userId, String name, String email, String photoUrl) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': name,
        'email': email,
        'status': 'Unavailable',
        'uid': userId,
        'profilePicture': photoUrl,
      });
    } catch (e) {
      print('Erro ao salvar dados do usuário: $e');
    }
  }

  Future<XFile> loadAssetAsXFile(String assetPath) async {
    ByteData data = await rootBundle.load(assetPath);
    Uint8List bytes = data.buffer.asUint8List();

    if (!kIsWeb) {
      Directory tempDir = await getTemporaryDirectory();
      File tempFile = File('${tempDir.path}/temp_image.png');
      await tempFile.writeAsBytes(bytes);
      return XFile(tempFile.path);
    }

    return XFile.fromData(bytes, name: 'asset_image.png');
  }

  String assetPath = 'assets/perfil/perfil-de-usuario.png';

  Future<void> saveImageToAppDirectoryFromBytes(String userId) async {
    XFile xFile = await loadAssetAsXFile(assetPath);
    await uploadProfilePicture(xFile, userId);
  }

  Future<(String? error, bool success)> onSignup(String email, String password,
      String name, XFile? profileImageFile) async {
    if (signupFormKey.currentState!.validate()) {
      try {
        FirebaseAuth _auth = FirebaseAuth.instance;

        // Criar usuário
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String userId = userCredential.user!.uid;

        // Upload da imagem de perfil
        String? photoUrl;
        if (profileImageFile != null) {
          print("Imagem de perfil fornecida, realizando upload...");
          photoUrl = await uploadProfilePicture(profileImageFile, userId);
        } else {
          print("Nenhuma imagem de perfil fornecida, usando imagem padrão...");
          await saveImageToAppDirectoryFromBytes(userId);
          photoUrl = await FirebaseStorage.instance
              .ref('profile_pictures/$userId')
              .getDownloadURL();
        }

        // Atualizar displayName e photoURL
        await userCredential.user!.updateDisplayName(name);
        await userCredential.user!.updatePhotoURL(photoUrl);

        // Salvar dados do usuário no Firestore
        await saveUserData(userId, name, email, photoUrl!);

        return (null, true);
      } catch (e) {
        print('Erro ao criar usuário: $e');
        return ('Erro ao criar usuário: $e', false);
      }
    }
    return (null, false);
  }
}
