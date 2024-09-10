import 'package:brtoon/firebase/firebase_storage_service.dart';
import 'package:brtoon/models/page_chapter_model.dart';
import 'package:brtoon/util_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class PagesController extends GetxController {
  final RxBool isLoading = false.obs;
  final utilsServices = UtilsServices();
  String? chapterId;
  final FirebaseStorageService _storageService = FirebaseStorageService();
  RxList<PageModel> allPages = <PageModel>[].obs;

  void setChapterId(String id) {
    chapterId = id;
    getAllPages();
  }

  Future<void> pages(String id) async {
    isLoading.value = true;
    chapterId = id;
    await getAllPages();
    isLoading.value = false;
  }

  Future<void> getAllPages() async {
    if (chapterId == null) {
      utilsServices.showToast(
        message: "ID do capitulo não fornecido.",
        isError: true,
      );
      return;
    }

    isLoading.value = true;

    try {
      Query query = FirebaseFirestore.instance
          .collection('pages')
          .where('chapterId', isEqualTo: chapterId);

      final querySnapshot = await query.get();

      List<PageModel> pages = querySnapshot.docs
          .map((doc) => PageModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      allPages.assignAll(pages);

      print('Capítulos da história selecionada: $pages');
    } catch (e) {
      print(e);
      utilsServices.showToast(
        message: "Erro ao obter capítulos: $e",
        isError: true,
      );
    }

    isLoading.value = false;
  }

  Future<void> downloadFile(
      {required String id, required String name, required int index}) async {
    if (!await _storageService.requestPermissions()) {
      utilsServices.showToast(
        message: "Permissões de armazenamento não concedidas",
        isError: true,
      );
      return;
    }
    // Iniciar o download usando Dio
    var dio = Dio();
    final downloadPath = await _storageService.chooseDirectory();
    if (downloadPath == null) {
      utilsServices.showToast(
          message: "Não foi possível acessar o diretório de download",
          isError: true);
      return;
    }
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('pages').doc(id).get();

      if (!doc.exists) {
        utilsServices.showToast(
          message: "pagina não encontrada.",
          isError: true,
        );
        isLoading.value = false;
        return;
      }
      PageModel page = PageModel.fromJson(doc.data() as Map<String, dynamic>);

      // Download the cover image
      if (page.imagePath.isNotEmpty) {
        final path = '$downloadPath/capitulo $name pagina $index.jpg';
        print('pagina : $downloadPath');
        var response = await dio.download(page.imagePath, path);
        if (response.statusCode == 200) {
          utilsServices.showToast(
            message: "Download concluído para $path",
          );
        } else {
          utilsServices.showToast(
            message:
                "Falha no download para $path com status ${response.statusCode}",
            isError: true,
          );
          print(
              "Falha no download para $path com status ${response.statusCode}");
        }
      }
    } catch (e) {
      print('Erro detalhado: $e'); // Log detalhado do erro
      utilsServices.showToast(
        message: "Erro durante o download em mobile $e",
        isError: true,
      );
      print("Erro durante o download em mobile $e");
    }
  }
}
