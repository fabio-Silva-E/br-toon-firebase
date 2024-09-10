import 'dart:io' as io;

import 'package:brtoon/home/result/home_result.dart';
import 'package:brtoon/models/category_model.dart';
import 'package:brtoon/models/chapter_model.dart';
import 'package:brtoon/models/item_models.dart';
import 'package:brtoon/publish_screen/repository/publish_repository.dart';
import 'package:brtoon/util_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

const int itemsPerPage = 6;

class PublishHistoryController extends GetxController {
  final PublishRepository _firebasePublishHistory = PublishRepository();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool isCategoryLoading = false;
  bool isProductLoading = true;
  bool isChangingCategory = false;
  List<CategoryModel> allCategories = [];
  CategoryModel? currentCategory;
  DocumentSnapshot? lastDocument;
  // Estado observável para armazenar mensagens de erro
  final RxString _errorMessage = RxString('');
  String get errorMessage => _errorMessage.value;

  // Estado observável para controlar o carregamento
  final RxBool isLoading = false.obs;
  final utilsServices = UtilsServices();

  List<HistoryModel> get allProducts => currentCategory?.history ?? [];
  RxString searchTitle = ''.obs;
  List<ChapterModel> allChapters = [];
  HistoryModel? currentItem;
  String? selectedCategoryId;
  bool get isLastPage {
    if (currentCategory!.history.length < itemsPerPage) return true;
    return currentCategory!.pagination * itemsPerPage > allProducts.length;
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllCategories();
  }

  void setLoading(
    bool value, {
    bool isProduct = false,
  }) {
    if (!isProduct) {
      isCategoryLoading = value;
    } else {
      isProductLoading = value;
    }
    update();
  }

  Future<void> fetchAllCategories() async {
    setLoading(true);
    HomeResult<CategoryModel> homeResult =
        await _firebasePublishHistory.fetchAllCategories();
    setLoading(false);
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
    setLoading(false);
  }

  void selectCategory(CategoryModel category) {
    currentCategory = category;
    lastDocument =
        null; // Resetar o último documento ao selecionar uma nova categoria
    update();
    if (currentCategory!.history.isNotEmpty) {
      return;
    }
    getAllProducts();
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
      User? user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      Query query = FirebaseFirestore.instance
          .collection('histories')
          .where('categoryId', isEqualTo: currentCategory!.id)
          .where('userId', isEqualTo: user.uid);

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

  // Remove uma história publicada, junto com seus capítulos e páginas
  Future<void> removePublishedHistory({required String historyId}) async {
    isLoading.value = true;
    final result =
        await _firebasePublishHistory.removePublishedHistory(historyId);
    if (result != null) {
      utilsServices.showToast(
        message: result,
        isError:
            result != 'História, capítulos e páginas removidos com sucesso',
      );
      if (result == 'História, capítulos e páginas removidos com sucesso') {
        // Recarrega a página
        currentCategory = currentCategory!.copyWith(
          history: currentCategory!.history
              .where((history) => history.id != historyId)
              .toList(),
        );
        lastDocument = null; // Resetar o último documento
        getAllProducts(); // Recarregar produtos
      }
    } else {
      utilsServices.showToast(
        message: 'Erro desconhecido ao remover história',
        isError: true,
      );
    }
    isLoading.value = false;
  }
}
