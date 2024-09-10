import 'dart:io' as io;

import 'package:brtoon/models/chapter_model.dart';
import 'package:brtoon/publications/repository/publications_repository.dart';
import 'package:brtoon/publications/screen/publish_pages_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class PublishChapterController extends GetxController {
  final RxBool isLoading = false.obs;
  final PublicationsRepository _firebasePublishChapter =
      PublicationsRepository();
  String? idHistory;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  void setHistoryId(String historyId) {
    idHistory = historyId;
  }

  @override
  void onInit() {
    super.onInit();
  }

  // Estado observável para armazenar mensagens de erro
  final RxString _errorMessage = RxString('');
  String get errorMessage => _errorMessage.value;

  Future<String?> addChapter(ChapterModel chapter) async {
    isLoading.value = true;

    if (idHistory != null) {
      ChapterModel updatedChapter = chapter.copyWith(idHistory: idHistory!);

      final result =
          await _firebasePublishChapter.addPublishChapter(updatedChapter);
      if (result != null) {
        isLoading.value = false;
        return result;
      } else {
        _errorMessage.value = ''; // Limpa a mensagem de erro em caso de sucesso
        isLoading.value = false;
        return updatedChapter.id; // Retorna o ID da história
      }
    } else {
      _errorMessage.value = 'Id da historia  não  encontrado';
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
          _firebaseStorage.ref().child('chapter-cape/$chapterId.jpg');

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

  // Publica o capítulo
  Future<void> publishChapter({
    required String title,
    required XFile image,
    required String historyId,
  }) async {
    isLoading.value = true;
    // Gere o ID para o novo capitulo
    final chapterId = DateTime.now().millisecondsSinceEpoch.toString();

    // Salva a imagem no Firebase e obtém a URL

    ChapterModel chapter = ChapterModel(
      id: chapterId,
      title: title,
      imagePath: '',
      pages: [],
      idHistory: historyId,
      postData: DateTime.now(),
    );
    // Salve a imagem e obtenha a URL
    final imageUrl = await saveImageToFirebase(image, chapterId);

    // Atualize o modelo History com a URL da imagem
    chapter = chapter.copyWith(imagePath: imageUrl);
    final addchapterId = await addChapter(chapter);
    isLoading.value = false;
    if (addchapterId != null) {
      Get.to(() => PublishPageTab(
          chapterId:
              addchapterId)); // Redireciona para a tela de publicação do capítulo
    }
  }
}
