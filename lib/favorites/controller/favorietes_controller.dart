import 'package:brtoon/favorites/repository/favorites_repository.dart';
import 'package:brtoon/home/controller/home_controller.dart';
import 'package:brtoon/home/repository/home_repository.dart';
import 'package:brtoon/home/result/home_result.dart';
import 'package:brtoon/likes/repository/like_repository.dart';
import 'package:brtoon/models/category_model.dart';
import 'package:brtoon/models/favorite_history_model.dart';
import 'package:brtoon/models/item_models.dart';
import 'package:brtoon/util_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

const int itemPerPage = 6;

class FavoritesController extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final utilsServices = UtilsServices();
  final favoritesRepository = FavoritesRepository();
  List<CategoryModel> allCategories = [];
  RxList<FavoriteHistoryModel> favorites = <FavoriteHistoryModel>[].obs;
  DocumentSnapshot? lastDocument;
  final homeController = Get.find<HomeController>();
  bool isProductLoading = true;
  RxInt favoritesCount = 0.obs;
  final homeRepository = HomeRepository();
  List<FavoriteHistoryModel> get allProducts =>
      currentCategory?.favorites ?? [];
  CategoryModel? currentCategory;
  final RxBool isLoading = false.obs;
  bool isCategoryLoading = false;
  final favoriteRepository = FavoritesRepository();
  RxString searchTitle = ''.obs;
  var count = <String, RxInt>{}.obs;

  final LikeRepository likeRepository = LikeRepository();
  bool get isLastPage {
    if (currentCategory == null) return true;
    if (currentCategory!.favorites!.length < itemPerPage) return true;
    return currentCategory!.pagination * itemPerPage > allProducts.length;
  }

  @override
  void onInit() {
    super.onInit();

    getFavoritesCountStream();
    debounce(
      searchTitle,
      (_) => filterByTitle(),
      time: const Duration(milliseconds: 600),
    );
    getAllCategory();
    //  updateCategoriesWithFavorites(favorites);
  }

  void updateCategoriesWithFavorites(List<FavoriteHistoryModel> allFavorites) {
    for (var i = 0; i < allCategories.length; i++) {
      List<FavoriteHistoryModel> categoryFavorites = allFavorites
          .where((fav) => fav.history.categoryId == allCategories[i].id)
          .toList();
      allCategories[i] =
          allCategories[i].copyWith(favorites: categoryFavorites);
    }
    update();
  }

  Future<void> removeItemFromFavorites(
      {required FavoriteHistoryModel item}) async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    final result = await favoritesRepository.removeItemFromFavorites(
      favoriteId: item.favoriteId,
    );

    if (result) {
      // Remova o item da lista local de favoritos de maneira segura
      favorites.removeWhere(
          (favoriteItem) => favoriteItem.favoriteId == item.favoriteId);

      updateCategoriesWithFavorites(favorites);

      // Atualize a contagem de favoritos
      await _updateFavoritesCount(increment: false);

      // Recarregar os produtos da categoria atual
      await getAllProducts(reload: true);

      // Notifique os ouvintes sobre a mudança
      update();

      // Mostrar mensagem de sucesso
      utilsServices.showToast(
        message: 'História removida de seus favoritos',
      );
    } else {
      utilsServices.showToast(
        message: 'Ocorreu um erro ao desfavoritar a história',
        isError: true,
      );
    }
  }

  Future<void> _updateFavoritesCount({required bool increment}) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await _firestore.runTransaction((transaction) async {
        final userDoc =
            _firestore.collection('usersFavoritesCount').doc(user.uid);
        final snapshot = await transaction.get(userDoc);

        if (snapshot.exists) {
          final currentCount = snapshot.data()?['favoritesCount'] ?? 0;
          final newCount = increment
              ? currentCount + 1
              : (currentCount > 0 ? currentCount - 1 : 0);

          // Log para depuração
          print('Current Count: $currentCount, New Count: $newCount');

          // Garantir que a contagem nunca seja negativa
          if (newCount < 0) {
            print('Erro: A contagem de favoritos não pode ser negativa.');
            return;
          }

          transaction.update(userDoc, {'favoritesCount': newCount});
        } else {
          // Se o documento do usuário não existir, criá-lo com a contagem inicial
          final initialCount = increment ? 1 : 0;
          print(
              'Documento não encontrado. Criando novo documento com contagem inicial: $initialCount');
          transaction.set(userDoc, {'favoritesCount': initialCount});
        }
      }).catchError((error) {
        print('Erro na transação: $error');
      });
    } else {
      print('Usuário não autenticado.');
    }
  }

  void loadMoreProducts() {
    if (currentCategory == null) return;

    currentCategory = currentCategory!.copyWith(
      pagination: currentCategory!.pagination + 1,
    );
    getAllProducts(canLoad: false);
  }

  void setLoading(bool value, {bool isProduct = false}) {
    if (!isProduct) {
      isCategoryLoading = value;
    } else {
      isProductLoading = value;
    }
    update();
  }

  void filterByTitle() {
    if (currentCategory == null) return;

    currentCategory = currentCategory!.copyWith(
      favorites: [],
    );
    lastDocument = null; // Reset the last document
    getAllProducts(); // Reload products based on title
    update();
  }

  void selectCategory(CategoryModel category) {
    if (currentCategory != category) {
      currentCategory = category;
      lastDocument =
          null; // Reset the last document when selecting a new category
      // Clear the favorites list to avoid duplications
      currentCategory = currentCategory!.copyWith(
        favorites: [],
      );
      updateCategoriesWithFavorites(
          favorites); // Update the category with an empty list
      update();
      getAllProducts(); // Reload products for the selected category
    }
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

  Future<void> getAllProducts(
      {bool canLoad = true, bool reload = false}) async {
    if (canLoad) {
      setLoading(true, isProduct: true);
    }

    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      if (currentCategory == null || currentCategory!.id == null) {
        throw Exception('Nenhuma categoria selecionada');
      }

      Query query = _firestore
          .collection('favorites')
          .where('userId', isEqualTo: user.uid)
          .where('history.categoryId', isEqualTo: currentCategory!.id);

      if (searchTitle.value.isNotEmpty) {
        String startAt = searchTitle.value;
        String endAt = searchTitle.value + '\uf8ff';

        query =
            query.orderBy('history.title').startAt([startAt]).endAt([endAt]);
      } else {
        query = query.orderBy('history.title');
      }

      query = query.limit(itemPerPage);

      if (!reload && lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }

      final querySnapshot = await query.get();

      List<FavoriteHistoryModel> products = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        var history = data['history'] as Map<String, dynamic>;

        String title = history['title'] ?? 'Título desconhecido';
        String categoryId =
            history['categoryId']?.toString() ?? 'Categoria desconhecida';
        String id = history['id']?.toString() ?? 'ID desconhecido';
        DateTime postData = history['postData'] is Timestamp
            ? (history['postData'] as Timestamp).toDate()
            : DateTime.tryParse(history['postData']?.toString() ?? '') ??
                DateTime.now();
        String imagePath = history['imagePath'] ?? '';
        String historyUserId = history['userId'] ?? 'Usuário desconhecido';

        return FavoriteHistoryModel(
          favoriteId: doc.id,
          user: data['userId'] as String,
          history: HistoryModel(
            title: title,
            categoryId: categoryId,
            id: id,
            postData: postData,
            imagePath: imagePath,
            userId: historyUserId,
          ),
        );
      }).toList();

      if (reload) {
        currentCategory = currentCategory!.copyWith(
          favorites: products,
        );
      } else if (products.isNotEmpty) {
        lastDocument = querySnapshot.docs.last; // Atualiza o último documento

        // Atualiza a categoria atual com os novos produtos
        currentCategory = currentCategory!.copyWith(
          favorites: [...currentCategory!.favorites ?? [], ...products],
        );

        // Adiciona novos produtos à lista de favoritos
        final existingIds = favorites.map((e) => e.history.id).toSet();
        final itemsToAdd = products
            .where((item) => !existingIds.contains(item.history.id))
            .toList();
        favorites.addAll(itemsToAdd);
      }

      removeDuplicateFavorites(); // Remover duplicados
      isProductLoading = false;
      update();
    } catch (e) {
      utilsServices.showToast(
        message: 'Erro ao carregar produtos: $e',
        isError: true,
      );
    } finally {
      isProductLoading = false;
      update();
    }
  }

  void removeDuplicateFavorites() {
    final uniqueFavorites = <FavoriteHistoryModel>{};
    favorites.forEach((item) => uniqueFavorites.add(item));
    favorites.assignAll(uniqueFavorites.toList());
  }

  Future<void> addItemToFavorites({required HistoryModel item}) async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    // Check if the item is already in favorites
    if (await isItemFavorite(item)) {
      utilsServices.showToast(
        message: 'Item já está nos favoritos',
        isError: false,
      );
      return;
    }

    final result = await favoritesRepository.addItemToFavorites(
      userId: user.uid,
      history: item,
    );

    result.when(
      success: (favoriteItemId) async {
        final newFavoriteItem = FavoriteHistoryModel(
          favoriteId: favoriteItemId,
          history: item,
        );
        // Update the favorites list and category
        favorites.add(newFavoriteItem);
        updateCategoriesWithFavorites(favorites);
        await _updateFavoritesCount(increment: true);
        await getAllProducts();

        update();
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  Future<bool> isItemFavorite(HistoryModel item) async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    try {
      // Referência para a coleção de favoritos do usuário logado
      final favoritesRef = _firestore.collection('favorites');

      // Consulta para verificar se o item está nos favoritos do usuário logado
      final querySnapshot = await favoritesRef
          .where('userId', isEqualTo: user.uid)
          .where('history.id', isEqualTo: item.id)
          .limit(1)
          .get();

      // Retorna true se o documento existir, ou seja, o item é favorito
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      utilsServices.showToast(
        message: 'Erro ao verificar se o item é favorito: $e',
        isError: true,
      );
      return false;
    }
  }

  Stream<int> getFavoritesCountStream() {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    return _firestore
        .collection('usersFavoritesCount')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        return data['favoritesCount'] ?? 0;
      } else {
        return 0;
      }
    });
  }
}
