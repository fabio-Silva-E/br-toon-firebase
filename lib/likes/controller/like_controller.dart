import 'package:brtoon/likes/repository/like_repository.dart';
import 'package:brtoon/util_services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LikeController extends GetxController {
  final LikeRepository likeRepository = LikeRepository();
  final UtilsServices utilsServices = UtilsServices();

  var isLiked = <String, RxBool>{}.obs;
  var likeCount = <String, RxInt>{}.obs;

  Future<void> checkLikeStatus(String like, String userId) async {
    print('Checking like status for userId: $userId, postId: $like');
    final result = await likeRepository.isLikedByUser(
      userId: userId,
      like: like,
    );

    if (result.data != null) {
      isLiked[like] = RxBool(result.data!);
      print('Like status for postId: $like is ${result.data}');
    } else {
      /* utilsServices.showToast(
        message: result.error ?? 'Erro desconhecido',
        isError: true,
      );*/
      print('Error checking like status: ${result.error}');
    }
  }

  Future<void> getLikeCount(String like) async {
    print('Getting like count for postId: $like');
    final result = await likeRepository.getLikeCount(like: like);

    if (result.data != null) {
      likeCount[like] = RxInt(result.data!);
      print('Like count for postId: $like is ${result.data}');
    } else {
      /* utilsServices.showToast(
        message: result.error ?? 'Erro desconhecido',
        isError: true,
      );*/
      print('Error getting like count: ${result.error}');
    }
  }

  Future<void> likePost(String like, String userId) async {
    print('Liking post. userId: $userId, like: $like');
    final result = await likeRepository.likePost(
      userId: userId,
      like: like,
    );

    if (result.data == true) {
      isLiked[like]?.value = true;
      likeCount[like]?.value = (likeCount[like]?.value ?? 0) + 1;
      print('Successfully liked the post. postId: $like');
    } else {
      /*utilsServices.showToast(
        message: result.error ?? 'Erro desconhecido',
        isError: true,
      );*/
      print('Error liking the post: ${result.error}');
    }
  }

  Future<void> unlikePost(String like, String userId) async {
    print('Unliking post. userId: $userId, postId: $like');
    final result = await likeRepository.unlikePost(
      userId: userId,
      like: like,
    );

    if (result.data == true) {
      isLiked[like]?.value = false;
      likeCount[like]?.value = (likeCount[like]?.value ?? 1) - 1;
      print('Successfully unliked the post. postId: $like');
    } else {
      /*  utilsServices.showToast(
        message: result.error ?? 'Erro desconhecido',
        isError: true,
      );*/
      print('Error unliking the post: ${result.error}');
    }
  }
}
