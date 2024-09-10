import 'package:brtoon/publications/controller/editing_controller.dart';
import 'package:get/get.dart';

class EditingCapeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditingController());
  }
}
