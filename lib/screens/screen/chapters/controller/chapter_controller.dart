import 'package:brtoon/firebase/firebase_storage_service.dart';
import 'package:brtoon/models/chapter_model.dart';
import 'package:brtoon/models/page_chapter_model.dart';
import 'package:brtoon/util_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ChapterController extends GetxController {
  final RxBool isLoading = false.obs;
  final utilsServices = UtilsServices();
  final FirebaseStorageService _storageService = FirebaseStorageService();
  String? historyId;
  RxList<ChapterModel> allChapters = <ChapterModel>[].obs;

  void setHistoryId(String id) {
    historyId = id;
    getAllChapters();
  }

  Future<void> chapters(String id) async {
    isLoading.value = true;
    historyId = id;
    await getAllChapters();
    isLoading.value = false;
  }

  Future<void> getAllChapters() async {
    if (historyId == null) {
      utilsServices.showToast(
        message: "ID da história não fornecido.",
        isError: true,
      );
      return;
    }

    isLoading.value = true;

    try {
      Query query = FirebaseFirestore.instance
          .collection('chapters')
          .where('idHistory', isEqualTo: historyId);

      final querySnapshot = await query.get();

      List<ChapterModel> chapters = querySnapshot.docs
          .map((doc) =>
              ChapterModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      allChapters.assignAll(chapters);

      print('Capítulos da história selecionada: $chapters');
    } catch (e) {
      print(e);
      utilsServices.showToast(
        message: "Erro ao obter capítulos: $e",
        isError: true,
      );
    }

    isLoading.value = false;
  }

  Future<void> downloadChapterContent(String chapterId) async {
    isLoading.value = true;
    if (!await _storageService.requestPermissions()) {
      utilsServices.showToast(
        message: "Permissões de armazenamento não concedidas",
        isError: true,
      );
      return;
    }
    var dio = Dio();
    final downloadPath = await _storageService.chooseDirectory();
    if (downloadPath == null) {
      utilsServices.showToast(
          message: "Não foi possível acessar o diretório de download",
          isError: true);
      return;
    }
    try {
      // Fetch the chapter details from Firestore
      DocumentSnapshot chapterDoc = await FirebaseFirestore.instance
          .collection('chapters')
          .doc(chapterId)
          .get();

      if (!chapterDoc.exists) {
        utilsServices.showToast(
          message: "Capítulo não encontrado.",
          isError: true,
        );
        isLoading.value = false;
        return;
      }

      ChapterModel chapter =
          ChapterModel.fromJson(chapterDoc.data() as Map<String, dynamic>);

      // Download the cover image
      if (chapter.imagePath.isNotEmpty) {
        final coverPath = '$downloadPath/Capa ${chapter.title}.jpg';
        var response = await dio.download(chapter.imagePath, coverPath);
        if (response.statusCode == 200) {
          utilsServices.showToast(
            message: "Download concluído para $coverPath",
          );
        } else {
          utilsServices.showToast(
            message:
                "Falha no download para $coverPath com status ${response.statusCode}",
            isError: true,
          );
        }
      }

      // Fetch the pages associated with the chapter
      Query pagesQuery = FirebaseFirestore.instance
          .collection('pages')
          .where('chapterId', isEqualTo: chapterId);

      final pagesQuerySnapshot = await pagesQuery.get();

      List<PageModel> pages = pagesQuerySnapshot.docs
          .map((doc) => PageModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      print(
          'Número de páginas encontradas: ${pages.length}'); // Adicione esta linha
      int index = 1;
      // Download each page
      for (PageModel page in pages) {
        if (page.imagePath.isNotEmpty) {
          final pagePath =
              '$downloadPath/Capítulo ${chapter.title} - Página $index.jpg';
          print("Baixando página para: $pagePath");
          var response = await dio.download(page.imagePath, pagePath);
          if (response.statusCode == 200) {
            utilsServices.showToast(
              message: "Download concluído para $pagePath",
            );
          } else {
            utilsServices.showToast(
              message:
                  "Falha no download para $pagePath com status ${response.statusCode}",
              isError: true,
            );
          }
          index++;
        }
      }
      utilsServices.showToast(
        message: "Download concluído.",
      );
    } catch (e) {
      print(e);
      utilsServices.showToast(
        message: "Erro durante o download: $e",
        isError: true,
      );
    }

    isLoading.value = false;
  }
}
