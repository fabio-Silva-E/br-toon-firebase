import 'package:brtoon/group_chats/Screens/UsersScreen.dart';
import 'package:brtoon/group_chats/controller/chat_controller.dart';

import 'package:get/get.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      UsersScreen(),
    );
    Get.put(ChatController());
  }
}
