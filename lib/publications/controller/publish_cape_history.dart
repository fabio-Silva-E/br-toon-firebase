import 'dart:io' as io;

import 'package:brtoon/models/category_model.dart';
import 'package:brtoon/models/chapter_model.dart';
import 'package:brtoon/models/item_models.dart';
import 'package:brtoon/publications/repository/publications_repository.dart';
import 'package:brtoon/publications/result/publications_result.dart';
import 'package:brtoon/publications/screen/publish_Chapter_screen.dart';
import 'package:brtoon/util_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart' show kIsWeb;

const int itemsPerPage = 6;

class PublishCapeHistoryController extends GetxController {
  final PublicationsRepository _firebasePublishHistory =
      PublicationsRepository();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  bool isCategoryLoading = false;
  bool isProductLoading = true;
  bool isChangingCategory = false;
  List<CategoryModel> allCategories = [];
  CategoryModel? currentCategory;
  DocumentSnapshot? lastDocument;

  final RxString _errorMessage = RxString('');
  String get errorMessage => _errorMessage.value;

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

  void setLoading(bool value, {bool isProduct = false}) {
    if (!isProduct) {
      isCategoryLoading = value;
    } else {
      isProductLoading = value;
    }
    update();
  }

  Future<void> fetchAllCategories() async {
    if (allCategories.isNotEmpty) return;

    setLoading(true);
    PublicationsResult<CategoryModel> homeResult =
        await _firebasePublishHistory.getAllCategories();
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
    selectedCategoryId = category.id;
    lastDocument =
        null; // Resetar o último documento ao selecionar uma nova categoria
    currentCategory = category;
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

  Future<String?> addPublishedHistory(HistoryModel history) async {
    isLoading.value = true;
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      HistoryModel updatedHistory = history.copyWith(userId: user.uid);

      // Initialize the like count to 0 for the new post
      final postRef =
          FirebaseFirestore.instance.collection('posts').doc(updatedHistory.id);
      await postRef.set({'likeCount': 0});

      final result =
          await _firebasePublishHistory.addPublishedHistory(updatedHistory);
      if (result != null) {
        isLoading.value = false;
        return updatedHistory.id;
      } else {
        _errorMessage.value = ''; // Clear the error message in case of success
        isLoading.value = false;
        return updatedHistory.id; // Return the ID of the story
      }
    } else {
      _errorMessage.value = 'User is not authenticated';
      isLoading.value = false;
      return null;
    }
  }

/*
  Future<String?> addPublishedHistoryAnonymous(HistoryModel history) async {
    isLoading.value = true;

    // Initialize the like count to 0 for the new post
    final postRef =
        FirebaseFirestore.instance.collection('posts').doc(history.id);
    await postRef.set({'likeCount': 0});

    // Remove userId before adding the story to Firestore
    final updatedHistory = history.copyWith(userId: null);

    final result =
        await _firebasePublishHistory.addPublishedHistory(updatedHistory);
    if (result != null) {
      isLoading.value = false;
      return updatedHistory.id;
    } else {
      _errorMessage.value = ''; // Clear the error message in case of success
      isLoading.value = false;
      return updatedHistory.id; // Return the ID of the story
    }
  }

  Future<void> publishHistoryAnonymous({
    required String title,
    required XFile image, // Alterado para receber o arquivo da imagem
    required String category,
  }) async {
    isLoading.value = true;

    // Gere o ID para a nova história
    final historyId = DateTime.now().millisecondsSinceEpoch.toString();

    // Crie o modelo History com o ID gerado
    HistoryModel history = HistoryModel(
      id: historyId,
      title: title,
      imagePath: '', // A imagem será atualizada depois
      postData: DateTime.now(),
      categoryId: category,
      // chapters: [],
      userId: _firebaseAuth.currentUser?.uid ?? '',
    );

    // Salve a imagem e obtenha a URL
    final imageUrl = await saveImageToFirebase(image, historyId);

    // Atualize o modelo History com a URL da imagem
    history = history.copyWith(imagePath: imageUrl);

    // Adicione a história ao Firestore
    final addedHistoryId = await addPublishedHistoryAnonymous(history);
    isLoading.value = false;

    if (addedHistoryId != null) {
      Get.to(() => PublishChapterTab(
          historyId:
              addedHistoryId)); // Redirecione para a tela de publicação do capítulo
    }
  }
*/
  Future<void> publishHistory({
    required String title,
    required XFile image, // Alterado para receber o arquivo da imagem
    required String category,
  }) async {
    isLoading.value = true;

    // Gere o ID para a nova história
    final historyId = DateTime.now().millisecondsSinceEpoch.toString();

    // Crie o modelo History com o ID gerado
    HistoryModel history = HistoryModel(
      id: historyId,
      title: title,
      imagePath: '', // A imagem será atualizada depois
      postData: DateTime.now(),
      categoryId: category,
      // chapters: [],
      userId: _firebaseAuth.currentUser?.uid ?? '',
    );

    // Salve a imagem e obtenha a URL
    final imageUrl = await saveImageToFirebase(image, historyId);

    // Atualize o modelo History com a URL da imagem
    history = history.copyWith(imagePath: imageUrl);

    // Adicione a história ao Firestore
    final addedHistoryId = await addPublishedHistory(history);
    isLoading.value = false;

    if (addedHistoryId != null) {
      Get.to(() => PublishChapterTab(
          historyId:
              addedHistoryId)); // Redirecione para a tela de publicação do capítulo
    }
  }

  Future<String> saveImageToFirebase(XFile image, String historyId) async {
    if (kIsWeb) {
      return saveImageToFirebaseForWeb(image, historyId);
    } else if (io.Platform.isAndroid || io.Platform.isIOS) {
      return saveImageToFirebaseForMobile(image, historyId);
    } else {
      throw UnsupportedError('Operação não suportada nesta plataforma');
    }
  }

  Future<String> saveImageToFirebaseForWeb(
      XFile image, String historyId) async {
    try {
      isLoading.value = true;
      // Use historyId como o nome do arquivo
      Reference ref = _firebaseStorage.ref().child('cape/$historyId.jpg');

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
      XFile image, String historyId) async {
    try {
      isLoading.value = true;
      // Use historyId como o nome do arquivo
      Reference ref = _firebaseStorage.ref().child('cape/$historyId.jpg');

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
}
