import 'package:brtoon/publish_screen/controller/publish_history.dart';
import 'package:get/get.dart';

class PublishersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PublishHistoryController());
  }
}
