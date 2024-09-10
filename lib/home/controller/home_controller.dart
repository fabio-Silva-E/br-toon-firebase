import 'package:brtoon/firebase/firebase_storage_service.dart';
import 'package:brtoon/home/repository/home_repository.dart';
import 'package:brtoon/home/result/home_result.dart';
import 'package:brtoon/models/category_model.dart';
import 'package:brtoon/models/chapter_model.dart';
import 'package:brtoon/models/item_models.dart';
import 'package:brtoon/models/page_chapter_model.dart';
import 'package:brtoon/util_services.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const int itemsPerPage = 6;

class HomeController extends GetxController {
  final utilsServices = UtilsServices();
  final homeRepository = HomeRepository();
  final RxBool isLoading = false.obs;
  bool isCategoryLoading = false;
  bool isProductLoading = true;

  List<CategoryModel> allCategories = [];
  CategoryModel? currentCategory;
  DocumentSnapshot? lastDocument; // Armazenar o último documento carregado
  final FirebaseStorageService _storageService = FirebaseStorageService();
  List<HistoryModel> get allProducts => currentCategory?.history ?? [];
  RxString searchTitle = ''.obs;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool get isLastPage {
    if (currentCategory!.history.length < itemsPerPage) return true;
    return currentCategory!.pagination * itemsPerPage > allProducts.length;
  }

  @override
  void onInit() {
    super.onInit();
    debounce(
      searchTitle,
      (_) => filterByTitle(),
      time: const Duration(milliseconds: 600),
    );
    getAllCategory();
  }

  void setLoading(bool value, {bool isProduct = false}) {
    if (!isProduct) {
      isCategoryLoading = value;
    } else {
      isProductLoading = value;
    }
    update();
  }

  Future<void> getAllCategory() async {
    setLoading(true);
    HomeResult<CategoryModel> homeResult =
        await homeRepository.getAllCategories();
    setLoading(false);
    homeResult.when(
      success: (data) {
        allCategories.assignAll(data);
        if (allCategories.isEmpty) return;
        selectCategory(allCategories.first);
      },
      error: (message) {
        utilsServices.showToast(message: message, isError: true);
      },
    );
  }

  void selectCategory(CategoryModel category) {
    lastDocument = null;
    currentCategory = category;
    update();

    if (currentCategory!.history.isNotEmpty) {
      return;
    }

    getAllProducts();
  }

  void filterByTitle() {
    currentCategory = currentCategory?.copyWith(
      history: [],
    );
    lastDocument = null; // Resetar o último documento
    getAllProducts();
    update();
  }

  void loadMoreProducts() {
    currentCategory = currentCategory!.copyWith(
      pagination: currentCategory!.pagination + 1,
    );
    getAllProducts(canLoad: false);
  }

  Future<void> getAllProducts({bool canLoad = true}) async {
    if (canLoad) {
      setLoading(true, isProduct: true);
    }

    try {
      Query query = FirebaseFirestore.instance
          .collection('histories')
          .where('categoryId', isEqualTo: currentCategory!.id);

      if (searchTitle.value.isNotEmpty) {
        String startAt = searchTitle.value;
        String endAt = searchTitle.value + '\uf8ff';

        query = query.orderBy('title').startAt([startAt]).endAt([endAt]);
      } else {
        query = query.orderBy('title');
      }

      query = query.limit(itemsPerPage);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }

      final querySnapshot = await query.get();

      List<HistoryModel> products = querySnapshot.docs
          .map((doc) =>
              HistoryModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      if (products.isNotEmpty) {
        lastDocument = querySnapshot.docs.last; // Atualiza o último documento
      }

      currentCategory = currentCategory!.copyWith(
        history: [...currentCategory!.history, ...products],
      );

      print(products);
    } catch (e) {
      print(e);
      utilsServices.showToast(
        message: "Erro ao obter produtos: $e",
        isError: true,
      );
    }

    setLoading(false, isProduct: true);
    update();
  }

  Future<void> downloadHistoryContent(String historyId) async {
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
      DocumentSnapshot historyDoc = await FirebaseFirestore.instance
          .collection('histories')
          .doc(historyId)
          .get();

      if (!historyDoc.exists) {
        utilsServices.showToast(
          message: "História não encontrada.",
          isError: true,
        );
        isLoading.value = false;
        return;
      }

      HistoryModel history =
          HistoryModel.fromJson(historyDoc.data() as Map<String, dynamic>);

      // Baixar a capa
      if (history.imagePath.isNotEmpty) {
        final coverPath = '$downloadPath/Capa ${history.title}.jpg';
        print("Baixando capa para: $coverPath");
        var response = await dio.download(history.imagePath, coverPath);
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

      Query chaptersQuery = FirebaseFirestore.instance
          .collection('chapters')
          .where('idHistory', isEqualTo: historyId);

      final chaptersQuerySnapshot = await chaptersQuery.get();

      List<ChapterModel> chapters = chaptersQuerySnapshot.docs
          .map((doc) =>
              ChapterModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      for (ChapterModel chapter in chapters) {
        // Baixar a capa do capítulo
        if (chapter.imagePath.isNotEmpty) {
          final chapterPath = '$downloadPath/Capítulo ${chapter.title}.jpg';
          print("Baixando capítulo para: $chapterPath");
          var response = await dio.download(chapter.imagePath, chapterPath);
          if (response.statusCode == 200) {
            utilsServices.showToast(
              message: "Download concluído para $chapterPath",
            );
          } else {
            utilsServices.showToast(
              message:
                  "Falha no download para $chapterPath com status ${response.statusCode}",
              isError: true,
            );
          }
        }

        Query pagesQuery = FirebaseFirestore.instance
            .collection('pages')
            .where('chapterId', isEqualTo: chapter.id);

        final pagesQuerySnapshot = await pagesQuery.get();

        List<PageModel> pages = pagesQuerySnapshot.docs
            .map(
                (doc) => PageModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        int index = 1;
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
      }

      utilsServices.showToast(
        message: "Download concluído.",
      );
    } catch (e) {
      utilsServices.showToast(
        message: "Erro durante o download: $e",
        isError: true,
      );
    }

    isLoading.value = false;
  }
}
