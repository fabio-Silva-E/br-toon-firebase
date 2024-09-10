import 'package:brtoon/publications/controller/publish_chapter_history.dart';
import 'package:get/get.dart';

class PublishChapterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PublishChapterController());
  }
}
