import 'dart:io';

import 'package:brtoon/models/category_model.dart';
import 'package:brtoon/publications/repository/publications_repository.dart';
import 'package:brtoon/publications/result/publications_result.dart';
import 'package:brtoon/screens/screen/chapters/controller/chapter_controller.dart';
import 'package:brtoon/screens/screen/pages/controller/pages_controller.dart';
import 'package:brtoon/util_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditingController extends GetxController {
  final PublicationsRepository _firebasePublishHistory =
      PublicationsRepository();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<CategoryModel> allCategories = [];
  final RxBool isLoading = false.obs;
  String? selectedCategoryId;
  final PagesController controller = Get.put(PagesController());
  final ChapterController chapterController = Get.put(ChapterController());
  final utilsServices = UtilsServices();
  @override
  void onInit() {
    super.onInit();

    fetchAllCategories();
  }

  // Função para atualizar a pagina
  Future<String?> updatePageHistory({
    required String pageId,
  }) async {
    try {
      // Chamar a função do repositório para atualizar a pagina
      String? result = await _firebasePublishHistory.updatePublishedPage(
        id: pageId,
        postData: DateTime.now(),
      );
      utilsServices.showToast(
        message: result.toString(),
      );
      return result; // Retorna o resultado da operação
    } catch (e) {
      return 'Erro ao atualizar a história no controller: $e'; // Retorna a mensagem de erro em caso de falha
    }
  }

  // Função para atualizar a capa e outros campos do capitulo publicada
  Future<String?> updateChapterHistory({
    required String chapterId,
    required String title,
  }) async {
    try {
      // Chamar a função do repositório para atualizar o capitulo
      String? result = await _firebasePublishHistory.updatePublishedChapter(
        id: chapterId,
        title: title,
        postData: DateTime.now(),
      );
      utilsServices.showToast(
        message: result.toString(),
      );
      return result; // Retorna o resultado da operação
    } catch (e) {
      return 'Erro ao atualizar a história no controller: $e'; // Retorna a mensagem de erro em caso de falha
    }
  }

  // Função para atualizar a capa e outros campos de uma história publicada
  Future<String?> updateCoverHistory({
    required String historyId,
    required String title,
    required String categoryId,
  }) async {
    try {
      // Chamar a função do repositório para atualizar a história
      String? result =
          await _firebasePublishHistory.updatePublishedHistoryCover(
        id: historyId,
        title: title,
        postData: DateTime.now(),
        categoryId: categoryId,
      );
      utilsServices.showToast(
        message: result.toString(),
      );
      return result; // Retorna o resultado da operação
    } catch (e) {
      return 'Erro ao atualizar a história no controller: $e'; // Retorna a mensagem de erro em caso de falha
    }
  }

  void selectCategory(CategoryModel category) {
    selectedCategoryId = category.id; // Defina o ID da categoria selecionada
    update();
  }

  Future<void> fetchAllCategories() async {
    if (allCategories.isNotEmpty) return;

    PublicationsResult<CategoryModel> homeResult =
        await _firebasePublishHistory.getAllCategories();

    homeResult.when(
      success: (data) {
        allCategories.assignAll(data);
        if (allCategories.isEmpty) return;
        selectCategory(allCategories.first);
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  Future<void> updateCover({
    required XFile newFile,
    required String historyId,
  }) async {
    isLoading.value = true;

    try {
      final ref = _storage.ref().child('cape/$historyId.jpg');
      if (kIsWeb) {
        await ref.putData(await newFile.readAsBytes());
      } else {
        await ref.putFile(File(newFile.path));
      }

      // Update the Firestore document with the new image URL
      String imageUrl = await ref.getDownloadURL();
      await _firestore.collection('histories').doc(historyId).update({
        'imagePath': imageUrl,
      });
    } catch (e) {
      print('Erro ao atualizar a capa: $e');
      utilsServices.showToast(
        message: 'Erro ao atualizar a capa: $e',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateChapter({
    required XFile newFile,
    required String chapterId,
  }) async {
    isLoading.value = true;

    try {
      final ref = _storage.ref().child('chapter-cape/$chapterId.jpg');
      if (kIsWeb) {
        await ref.putData(await newFile.readAsBytes());
      } else {
        await ref.putFile(File(newFile.path));
      }

      // Update the Firestore document with the new image URL
      String imageUrl = await ref.getDownloadURL();
      await _firestore.collection('chapters').doc(chapterId).update({
        'imagePath': imageUrl,
      });
    } catch (e) {
      print('Erro ao atualizar a capa: $e');
      utilsServices.showToast(
        message: 'Erro ao atualizar a capa: $e',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePage(
      {required XFile newFile, required String pageId}) async {
    isLoading.value = true;

    try {
      final ref = _storage.ref().child('pages-chapter/$pageId.jpg');
      if (kIsWeb) {
        await ref.putData(await newFile.readAsBytes());
      } else {
        await ref.putFile(File(newFile.path));
      }

      // Update the Firestore document with the new image URL
      String imageUrl = await ref.getDownloadURL();
      await _firestore.collection('chapters').doc(pageId).update({
        'imagePath': imageUrl,
      });
    } catch (e) {
      print('Erro ao atualizar a capa: $e');
      utilsServices.showToast(
        message: 'Erro ao atualizar a capa: $e',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Function to remove a published page
  Future<void> removePage(String pageId, String imagePath) async {
    isLoading.value = true;

    final result =
        await _firebasePublishHistory.removePublishedPage(pageId, imagePath);
    utilsServices.showToast(
      message: result ?? 'Erro desconhecido ao remover página',
      isError: result != 'Página removida com sucesso',
    );

    if (result == 'Página removida com sucesso') {
      // Refresh the pages list after deletion
      await controller.getAllPages();
      controller.update(); // Notify GetX to update the UI
    }

    isLoading.value = false;
  }

  // Function to remove a published chapter and its pages
  Future<void> removeChapter(String chapterId, String chapterImagePath) async {
    isLoading.value = true;

    final result = await _firebasePublishHistory.removePublishedChapter(
        chapterId, chapterImagePath);
    utilsServices.showToast(
      message: result ?? 'Erro desconhecido ao remover capítulo',
      isError: result != 'Capítulo e páginas removidos com sucesso',
    );

    if (result == 'Capítulo e páginas removidos com sucesso') {
      // Refresh the chapters and pages list after deletion
      await chapterController.getAllChapters();
      chapterController.update(); // Notify GetX to update the UI
    }

    isLoading.value = false;
  }
}
