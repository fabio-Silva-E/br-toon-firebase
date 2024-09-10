import 'package:brtoon/util_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirebaseAuthService {
  static final FirebaseAuthService _singleton = FirebaseAuthService._internal();
  var isLoading = true.obs;
  final utilsServices = UtilsServices();
  factory FirebaseAuthService() {
    return _singleton;
  }

  FirebaseAuthService._internal();
  static User? get getUser => FirebaseAuth.instance.currentUser;
  static Stream<User?> getUserStream(BuildContext contex) =>
      FirebaseAuth.instance.authStateChanges();

  static Future<String?> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  static Future<(String? error, UserCredential?)> signup(
      String email, String password) async {
    try {
      final UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return (null, user);
    } on FirebaseAuthException catch (error) {
      return (error.message, null);
    }
  }

  static Future<String?> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
    return null;
  }

  static Future<String?> getUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  /*static Future<void> uploadProfilePicture(
      String userId, File imageFile) async {
    final storageRef =
        FirebaseStorage.instance.ref().child('profile_pictures/$userId');
    final uploadTask = storageRef.putFile(imageFile);
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'profilePicture': downloadUrl,
    });
  }*/

  static Future<String?> getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName;
  }

  // Recupera o e-mail do usuário logado
  static Future<String?> getUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  Future<void> updateUserName({
    required String currentPassword,
    required String newName,
  }) async {
    try {
      isLoading.value = true;

      // Reautenticando o usuário com a senha atual
      await reauthenticateUserWithPassword(currentPassword);

      // Atualizando o nome no Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;
      await user?.updateDisplayName(newName);

      // Atualizando o nome no Firestore
      final userId = await getUserId();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'name': newName});

      utilsServices.showToast(
        message: 'Nome atualizado com sucesso.',
      );
    } on FirebaseAuthException catch (e) {
      utilsServices.showToast(
        message: 'Senha incorreta. Por favor, tente novamente.',
        isError: true,
      );

      print('erro $e');
    } catch (e) {
      utilsServices.showToast(
        message: 'Erro ao atualizar o nome: $e',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserPassword(
      {required String currentPassword, required String newPassword}) async {
    try {
      isLoading.value = true;
      // Reautenticando o usuário com a senha atual
      await reauthenticateUserWithPassword(currentPassword);

      // Atualizando a senha
      User? user = FirebaseAuth.instance.currentUser;
      await user?.updatePassword(newPassword);
      utilsServices.showToast(
        message: '  Senha atualizada com sucesso',
      );
    } on FirebaseAuthException catch (e) {
      utilsServices.showToast(
        message: 'Senha incorreta. Por favor, tente novamente.',
        isError: true,
      );
    } catch (e) {
      utilsServices.showToast(
        message: 'Erro ao atualizar a senha: $e',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> reauthenticateUserWithPassword(String currentPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Obtendo o email do usuário logado
        String? email = user.email;

        if (email == null) {
          throw Exception('O email do usuário não foi encontrado.');
        }

        // Criando a credencial usando o email e a senha atual
        AuthCredential credential = EmailAuthProvider.credential(
            email: email, password: currentPassword);

        // Reautenticando o usuário
        await user.reauthenticateWithCredential(credential);
        print('Usuário reautenticado com sucesso.');
      } catch (e) {
        print('Erro ao reautenticar o usuário: $e');
        throw e;
      }
    } else {
      print('Usuário não autenticado.');
      throw Exception('Usuário não autenticado.');
    }
  }
}
