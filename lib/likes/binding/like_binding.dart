import 'package:brtoon/likes/controller/like_controller.dart';
import 'package:get/get.dart';

class LikeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LikeController());
  }
}
