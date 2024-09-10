import 'package:brtoon/favorites/controller/favorietes_controller.dart';
import 'package:get/get.dart';

class FavoritesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FavoritesController());
  }
}
