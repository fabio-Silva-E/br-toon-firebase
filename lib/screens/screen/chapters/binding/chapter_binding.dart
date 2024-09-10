import 'package:brtoon/screens/screen/chapters/controller/chapter_controller.dart';
import 'package:get/get.dart';

class ChapterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChapterController());
  }
}
