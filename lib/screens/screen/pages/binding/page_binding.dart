import 'package:brtoon/screens/screen/pages/controller/pages_controller.dart';
import 'package:get/get.dart';

class PagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PagesController());
  }
}
