import 'package:brtoon/common_widgets/showOrderConfirmation_widgest.dart';
import 'package:brtoon/models/chapter_model.dart';
import 'package:brtoon/models/page_chapter_model.dart';
import 'package:brtoon/screens/screen/pages/controller/pages_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageTile extends StatefulWidget {
  final String chapterId;
  final int index;
  const PageTile({
    Key? key,
    required this.chapterId,
    required this.page,
    required this.index,
    required this.chapter,
  }) : super(key: key);
  final PageModel page;
  final ChapterModel chapter;
  @override
  State<PageTile> createState() => _PageTileState();
}

class _PageTileState extends State<PageTile> {
  final GlobalKey imageGk = GlobalKey();
  final productPagesChapterController = Get.find<PagesController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.5),
      child: Column(
        // Substituindo Stack por Column
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
            widget.page.imagePath,
            key: imageGk,
            fit: BoxFit.cover,
          ),
          Container(
            // Este container agora está abaixo da imagem
            color: Colors.black.withOpacity(0.5),
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Capítulo ${widget.chapter.title}, Página ${widget.index}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    bool? result =
                        await ShowOrderConfirmation.showOrderConfirmation(
                      context,
                      'Confirmar download desta página?',
                      'Sim',
                      'Não',
                    );
                    if (result ?? false) {
                      productPagesChapterController.downloadFile(
                        id: widget.page.id,
                        name: "Capítulo ${widget.chapter.title}",
                        index: widget.index,
                      );
                    }
                  },
                  child: const Icon(
                    Icons.download, // Ícone de download
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
