import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class LikeResult<T> {
  final T? data;
  final String? error;

  LikeResult.success(this.data) : error = null;
  LikeResult.error(this.error) : data = null;
}

class LikeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger logger = Logger();

  Future<LikeResult<bool>> likePost({
    required String userId,
    required String like,
  }) async {
    try {
      final likeDocId = '$like:$userId';
      final likeDocRef = _firestore.collection('likes').doc(likeDocId);

      // Verifica se o like já existe
      final likeDocSnapshot = await likeDocRef.get();
      if (likeDocSnapshot.exists && likeDocSnapshot.data()?['liked'] == true) {
        logger.d('Post $like already liked by user $userId');
        return LikeResult.success(false); // Já está curtido
      }

      // Adiciona ou atualiza o like
      await likeDocRef.set({
        'userId': userId,
        'postId': like,
        'liked': true,
      }, SetOptions(merge: true));

      // Atualiza a contagem de curtidas no documento do post
      final postRef = _firestore.collection('posts').doc(like);
      await _firestore.runTransaction((transaction) async {
        final postSnapshot = await transaction.get(postRef);
        if (postSnapshot.exists) {
          final postData = postSnapshot.data()!;
          final likeCount = (postData['likeCount'] ?? 0) + 1;
          transaction.update(postRef, {'likeCount': likeCount});
        } else {
          transaction.set(postRef, {'likeCount': 1});
        }
      });

      logger.d('Liked post: $like by user: $userId');
      return LikeResult.success(true);
    } catch (e) {
      logger.e('Failed to like post: $e');
      return LikeResult.error('Não foi possível adicionar o like');
    }
  }

  Future<LikeResult<bool>> unlikePost({
    required String userId,
    required String like,
  }) async {
    try {
      final likeDocId = '$like:$userId';
      final likeDocRef = _firestore.collection('likes').doc(likeDocId);

      // Verifica se o like existe e está ativo
      final likeDocSnapshot = await likeDocRef.get();
      if (!likeDocSnapshot.exists || likeDocSnapshot.data()?['liked'] != true) {
        logger.d('Post $like not liked by user $userId');
        return LikeResult.success(false); // Não estava curtido
      }

      // Atualiza o like para false
      await likeDocRef.update({
        'liked': false,
      });

      // Atualiza a contagem de curtidas no documento do post
      final postRef = _firestore.collection('posts').doc(like);
      await _firestore.runTransaction((transaction) async {
        final postSnapshot = await transaction.get(postRef);
        if (postSnapshot.exists) {
          final postData = postSnapshot.data()!;
          final likeCount = (postData['likeCount'] ?? 1) -
              1; // Garantir que não fique negativo
          transaction.update(postRef, {'likeCount': likeCount});
        }
      });

      logger.d('Unliked post: $like by user: $userId');
      return LikeResult.success(true);
    } catch (e) {
      logger.e('Failed to unlike post: $e');
      return LikeResult.error('Não foi possível remover o like');
    }
  }

  Future<LikeResult<int>> getLikeCount({
    required String like,
  }) async {
    try {
      final postRef = _firestore.collection('posts').doc(like);
      final postSnapshot = await postRef.get();
      if (postSnapshot.exists && postSnapshot.data() != null) {
        final data = postSnapshot.data()!;
        final likeCount = data['likeCount'] ?? 0; // Inicia com 1 se não existir
        logger.d('Like count for post $like: $likeCount');
        return LikeResult.success(likeCount);
      } else {
        logger.e('Post $like does not exist');
        return LikeResult.error(
            'Não foi possível recuperar os likes desta história');
      }
    } catch (e) {
      logger.e('Failed to get like count: $e');
      return LikeResult.error(
          'Não foi possível recuperar os likes desta história');
    }
  }

  Future<LikeResult<bool>> isLikedByUser({
    required String userId,
    required String like,
  }) async {
    try {
      final likeDocId = '$like:$userId';
      final likeDocRef = _firestore.collection('likes').doc(likeDocId);
      final likeDocSnapshot = await likeDocRef.get();
      if (likeDocSnapshot.exists && likeDocSnapshot.data() != null) {
        final data = likeDocSnapshot.data()!;
        final isLiked = data['liked'] == true;
        logger.d('Post $like is liked by user $userId: $isLiked');
        return LikeResult.success(isLiked);
      } else {
        logger.e('Post $like does not exist or user $userId has not liked it');
        return LikeResult.error('Não foi possível checar o estado do like');
      }
    } catch (e) {
      logger.e('Failed to check like status: $e');
      return LikeResult.error('Não foi possível checar o estado do like');
    }
  }
}
