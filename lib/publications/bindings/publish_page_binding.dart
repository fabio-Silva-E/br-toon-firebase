import 'package:brtoon/publications/controller/publishi_page_history.dart';
import 'package:get/get.dart';

class PublishPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PublishPageController());
  }
}
