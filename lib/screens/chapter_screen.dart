import 'package:brtoon/config/custom_colors.dart';
import 'package:brtoon/models/item_models.dart';
import 'package:brtoon/screens/components/chapter_tile.dart';
import 'package:brtoon/screens/screen/chapters/controller/chapter_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChapterScreen extends StatefulWidget {
  final String historyId;
  final HistoryModel item;
  const ChapterScreen({
    Key? key,
    required this.historyId,
    required this.item,
  }) : super(key: key);

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  late ChapterController chapterController;
  final RxBool _isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    chapterController = Get.put(ChapterController());
    chapterController.setHistoryId(widget.historyId);

    // Observe isLoading from the controller
    ever(chapterController.isLoading, (isLoading) {
      _isLoading.value = isLoading as bool;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.item.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Obx(() {
        if (_isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Column(children: [
            Expanded(
              child: GetBuilder<ChapterController>(builder: (controller) {
                if (controller.allChapters.isEmpty) {
                  return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 40,
                            color: CustomColors.customSwatchColor,
                          ),
                          const Text(
                            'Não há capítulos postados',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ]),
                  );
                }
                return ListView.builder(
                  itemCount: controller.allChapters.length,
                  itemBuilder: (_, index) {
                    return ChapterTile(
                      chapter: controller.allChapters[index],
                      productId: widget.historyId,
                      item: widget.item,
                      index: index + 1,
                    );
                  },
                );
              }),
            ),
          ]);
        }
      }),
    );
  }
}
