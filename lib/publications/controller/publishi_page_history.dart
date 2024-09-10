import 'dart:io' as io;

import 'package:brtoon/models/page_chapter_model.dart';
import 'package:brtoon/publications/repository/publications_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class PublishPageController extends GetxController {
  final RxBool isLoading = false.obs;
  final PublicationsRepository _firebasePublishPage = PublicationsRepository();
  String? chapterId;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  void setChapter(String chapterId) {
    this.chapterId = chapterId;
  }

  final RxString _errorMessage = RxString('');
  String get errorMessage => _errorMessage.value;

  Future<String?> addPage(PageModel page) async {
    isLoading.value = true;

    if (chapterId != null) {
      PageModel updatedPage = page.copyWith(chapterId: chapterId!);
      final result = await _firebasePublishPage.addPublishPage(updatedPage);
      isLoading.value = false;
      return result ?? updatedPage.id;
    } else {
      _errorMessage.value = 'ID do capítulo não encontrado';
      isLoading.value = false;
      return null;
    }
  }

  Future<String> saveImageToFirebase(XFile image, String chapterId) async {
    if (kIsWeb) {
      return saveImageToFirebaseForWeb(image, chapterId);
    } else if (io.Platform.isAndroid || io.Platform.isIOS) {
      return saveImageToFirebaseForMobile(image, chapterId);
    } else {
      throw UnsupportedError('Operação não suportada nesta plataforma');
    }
  }

  Future<String> saveImageToFirebaseForWeb(
      XFile image, String chapterId) async {
    try {
      isLoading.value = true;
      // Use historyId como o nome do arquivo
      Reference ref =
          _firebaseStorage.ref().child('pages-chapter/$chapterId.jpg');

      UploadTask uploadTask = ref.putData(await image.readAsBytes());
      TaskSnapshot snapshot = await uploadTask;

      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Erro ao carregar imagem (web): $e');
      throw Exception('Falha ao carregar imagem (web): $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> saveImageToFirebaseForMobile(
      XFile image, String chapterId) async {
    try {
      isLoading.value = true;
      // Use historyId como o nome do arquivo
      Reference ref = _firebaseStorage.ref().child('cape/$chapterId.jpg');

      UploadTask uploadTask = ref.putFile(io.File(image.path));
      TaskSnapshot snapshot = await uploadTask;

      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Erro ao carregar imagem (mobile): $e');
      throw Exception('Falha ao carregar imagem (mobile): $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> publishPage({
    required XFile image,
    required String chapterId,
  }) async {
    isLoading.value = true;

    final pageId = DateTime.now().millisecondsSinceEpoch.toString();

    PageModel page = PageModel(
      id: pageId,
      imagePath: '',
      chapterId: chapterId,
      postData: DateTime.now(),
    );
    final imageUrl = await saveImageToFirebase(image, pageId);
    page = page.copyWith(imagePath: imageUrl);
    await addPage(page);
    print('Dados da página a serem publicados: ${page.toJson()}');

    String? result = await addPage(page);
    if (result != null) {
      print('Página publicada com ID: $result');
    } else {
      print('Falha ao publicar a página');
    }

    isLoading.value = false;
  }
}
