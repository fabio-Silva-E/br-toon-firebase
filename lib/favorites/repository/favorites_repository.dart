import 'package:brtoon/favorites/result/favorites_result.dart';

import 'package:brtoon/models/favorite_history_model.dart';
import 'package:brtoon/models/item_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class LikeResult<T> {
  final T? data;
  final String? error;

  LikeResult.success(this.data) : error = null;
  LikeResult.error(this.error) : data = null;
}

class FavoritesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger logger = Logger();
  Future<FavoritesResult<List<FavoriteHistoryModel>>> getFavoritesItems({
    required int itemPerPage,
    required DocumentSnapshot?
        lastDocument, // Último documento da página anterior
    required String userId,
    String? categoryId,
    String? title,
  }) async {
    try {
      Query query =
          _firestore.collection('favorites').where('userId', isEqualTo: userId);

      if (categoryId != null) {
        query = query.where('history.categoryId', isEqualTo: categoryId);
      }
      if (title != null) {
        query = query.where('history.title', isEqualTo: title);
      }

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      query = query.limit(itemPerPage);

      QuerySnapshot querySnapshot = await query.get();
      List<FavoriteHistoryModel> data = querySnapshot.docs
          .map((doc) => FavoriteHistoryModel.fromFirestore(doc))
          .toList();
      return FavoritesResult<List<FavoriteHistoryModel>>.success(data);
    } catch (e) {
      return FavoritesResult.error(
          'Ocorreu um erro ao recuperar as histórias de seus favoritos: $e');
    }
  }

  Future<FavoritesResult<List<FavoriteHistoryModel>>> getAllFavoritesItems({
    required String userId,
  }) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('favorites')
          .where('userId', isEqualTo: userId)
          .get();
      List<FavoriteHistoryModel> data = querySnapshot.docs
          .map((doc) => FavoriteHistoryModel.fromFirestore(doc))
          .toList();
      return FavoritesResult<List<FavoriteHistoryModel>>.success(data);
    } catch (e) {
      return FavoritesResult.error(
          'Ocorreu um erro ao recuperar as histórias de seus favoritos: $e');
    }
  }

  Future<bool> removeItemFromFavorites({
    required String favoriteId,
  }) async {
    try {
      await _firestore.collection('favorites').doc(favoriteId).delete();
      return true;
    } catch (e) {
      print('Erro ao remover item dos favoritos: $e');
      return false;
    }
  }

  Future<FavoritesResult<String>> addItemToFavorites({
    required String userId,
    required HistoryModel history,
  }) async {
    try {
      DocumentReference docRef = await _firestore.collection('favorites').add({
        'userId': userId,
        'history': history.toJson(),
      });
      return FavoritesResult.success(docRef.id);
    } catch (e) {
      return FavoritesResult.error(
          'Não foi possível adicionar a história aos seus favoritos: $e');
    }
  }
}
