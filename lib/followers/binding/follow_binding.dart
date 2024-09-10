import 'package:brtoon/followers/controller/folowers_controller.dart';
import 'package:get/get.dart';

class FollowBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FollowController());
  }
}
