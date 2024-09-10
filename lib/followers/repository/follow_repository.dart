import 'package:brtoon/models/user_chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:brtoon/util_services.dart';

class FollowRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentSnapshot? _lastDocument;
  final UtilsServices utilsServices = UtilsServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<PostResult<UserChatModel>> getAllPerfil() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();

      List<UserChatModel> usuarios = querySnapshot.docs
          .map((doc) => UserChatModel.fromFirestore(doc))
          .toList();

      print('usuarios $usuarios'); // Mantenha o print para depuração

      return PostResult<UserChatModel>.success(usuarios);
    } catch (e) {
      print('Error getting profiles: $e');
      return PostResult.error(
          'Ocorreu um erro inesperado ao recuperar os perfis');
    }
  }

  Future<PostUserResult> follow(String userId) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }
      await _firestore.collection('followers').add({
        'follower': user.uid,
        'followed': userId,
      });

      return PostUserResult.success('Seguindo ');
    } catch (e) {
      print('Error following user: $e');
      return PostUserResult.error('Não foi possível seguir ');
    }
  }

  Future<PostUserResult<String>> unfollow(String userId) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }
      final querySnapshot = await _firestore
          .collection('followers')
          .where('followed', isEqualTo: userId)
          .where('follower', isEqualTo: user.uid)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      return PostUserResult.success('Deixou de seguir com sucesso');
    } catch (e) {
      print('Error unfollowing user: $e');
      return PostUserResult.error(
          'Não foi possível deixar de seguir o usuário');
    }
  }

  Future<PostUserResult<bool>> checkIfFollowing(String userId) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }
      final querySnapshot = await _firestore
          .collection('followers')
          .where('follower', isEqualTo: user.uid)
          .where('followed', isEqualTo: userId)
          .get();

      bool isFollowing = querySnapshot.docs.isNotEmpty;

      return PostUserResult.success(isFollowing);
    } catch (e) {
      print('Error checking if following: $e');
      return PostUserResult.error(
          'Não foi possível verificar se está seguindo');
    }
  }
}

class PostResult<T> {
  final List<T>? data;
  final String? error;

  PostResult.success(this.data) : error = null;
  PostResult.error(this.error) : data = null;
}

class PostUserResult<T> {
  final T? data;
  final String? error;

  PostUserResult.success(this.data) : error = null;
  PostUserResult.error(this.error) : data = null;
}
