import 'package:brtoon/publications/controller/publish_cape_history.dart';
import 'package:get/get.dart';

class PublishCapeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PublishCapeHistoryController());
  }
}
