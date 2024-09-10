import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var hasUnreadMessages = false.obs;
  // ID do usuário logado

  @override
  void onInit() {
    super.onInit();
    print('usuario logado ${FirebaseAuth.instance.currentUser!.uid}');
    _listenForNewMessages();
  }

  void _listenForNewMessages() {
    FirebaseFirestore.instance
        .collection('chats')
        .where('recipientId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('isRead',
            isEqualTo: false) // Filtrar apenas as mensagens não lidas
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        updateUnreadMessagesStatus(true);
      } else {
        updateUnreadMessagesStatus(false);
      }
    });
  }

  void updateUnreadMessagesStatus(bool status) {
    hasUnreadMessages.value = status;
  }
}
