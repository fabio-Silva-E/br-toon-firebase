import 'package:brtoon/followers/repository/follow_repository.dart';
import 'package:brtoon/models/chat_model.dart';
import 'package:brtoon/models/follow_users_model.dart';
import 'package:brtoon/models/user_chat_model.dart';
import 'package:brtoon/profile/controller/author_profile_controller.dart';
import 'package:brtoon/util_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const int itemPerPage = 6;

class FollowController extends GetxController {
  final chatRepository = FollowRepository();
  RxBool isLoading = true.obs;
  RxBool isFollowing = false.obs;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ScrollController scrollController = ScrollController();
  final utilsServices = UtilsServices();
  final AuthorProfileController perfilController =
      Get.put(AuthorProfileController());
  FollowUsersModel? followed = FollowUsersModel();
  bool isEditorLoading = false;
  bool isPostLoading = true;

  List<ChatModel> get allEditors => currenteditor?.message ?? [];
  List<UserChatModel> allUser = [];
  UserChatModel? currenteditor;
  RxString searchTitle = ''.obs;
  RxBool loading = false.obs;
  String? followedId;
  List<DocumentSnapshot> _users = [];
  bool get isLastPage {
    if (currenteditor!.message.length < itemPerPage) return true;
    return currenteditor!.pagination * itemPerPage > allEditors.length;
  }

  Future<void> follow(String userId) async {
    try {
      // Fetch the user's name from the Firestore 'users' collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        String name = userDoc['name'];

        // Perform the follow action
        final result = await chatRepository.follow(userId);
        if (result.error == null) {
          utilsServices.showToast(
            message: 'Agora você está seguindo $name',
          );
          isFollowing.value = true;
          update();
        } else {
          utilsServices.showToast(
            message: result.error!,
            isError: true,
          );
          print('Error following the user: ${result.error}');
        }
      } else {
        utilsServices.showToast(
          message: 'Usuário não encontrado',
          isError: true,
        );
      }
    } catch (e) {
      utilsServices.showToast(
        message: 'Erro ao buscar informações do usuário',
        isError: true,
      );
      print('Error fetching user data: $e');
    }
  }

  Future<void> unFollow(String userId) async {
    try {
      // Fetch the user's name from the Firestore 'users' collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        String name = userDoc['name'];

        // Perform the unfollow action
        final result = await chatRepository.unfollow(userId);
        if (result.error == null) {
          utilsServices.showToast(
            message: 'Você não está mais seguindo $name',
          );
          isFollowing.value = false;
        } else {
          utilsServices.showToast(
            message: result.error!,
            isError: true,
          );
          print('Error unfollowing the user: ${result.error}');
        }
      } else {
        utilsServices.showToast(
          message: 'Usuário não encontrado',
          isError: true,
        );
      }
    } catch (e) {
      utilsServices.showToast(
        message: 'Erro ao buscar informações do usuário',
        isError: true,
      );
      print('Error fetching user data: $e');
    }
  }

  Future<void> checkIfFollowing(String userId) async {
    final result = await chatRepository.checkIfFollowing(userId);
    if (result.error == null) {
      isFollowing.value = result.data!;
      print('Following status for userId: $userId is ${result.data}');
    } else {
      utilsServices.showToast(
        message: result.error!,
        isError: true,
      );
      print('Error checking following status: ${result.error}');
    }
  }
}
