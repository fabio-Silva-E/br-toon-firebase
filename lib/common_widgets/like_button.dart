import 'package:brtoon/likes/controller/like_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LikeButton extends StatefulWidget {
  final String post;
  final String userId;

  const LikeButton({
    Key? key,
    required this.post,
    required this.userId,
  }) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late final LikeController likeController;

  @override
  void initState() {
    super.initState();
    likeController = Get.find<LikeController>();

    // Initialize the state for this particular LikeButton
    likeController.checkLikeStatus(widget.post, widget.userId);
    likeController.getLikeCount(widget.post);
  }

  String formatLikeCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)} mi';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)} mil';
    } else {
      return count.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Fetch the correct state for the specific post
      bool isLiked = likeController.isLiked[widget.post]?.value ?? false;
      int likeCount = likeController.likeCount[widget.post]?.value ?? 0;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              formatLikeCount(likeCount),
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4), // Spacing between text and icon
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.white,
            ),
            onPressed: () {
              if (isLiked) {
                likeController.unlikePost(widget.post, widget.userId).then((_) {
                  setState(() {}); // Trigger a rebuild to reflect changes
                });
              } else {
                likeController.likePost(widget.post, widget.userId).then((_) {
                  setState(() {}); // Trigger a rebuild to reflect changes
                });
              }
            },
          ),
        ],
      );
    });
  }
}
