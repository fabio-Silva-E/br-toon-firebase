import 'package:brtoon/common_widgets/interstitial_widget.dart';
import 'package:brtoon/common_widgets/showOrderConfirmation_widgest.dart';
import 'package:brtoon/models/chapter_model.dart';
import 'package:brtoon/models/item_models.dart';
import 'package:brtoon/screens/screen/chapters/controller/chapter_controller.dart';
import 'package:brtoon/screens/screen/page_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChapterTile extends StatefulWidget {
  final String productId;
  final int index;
  const ChapterTile({
    Key? key,
    required this.productId,
    required this.item,
    required this.chapter,
    required this.index,
  }) : super(key: key);
  final HistoryModel item;
  final ChapterModel chapter;

  @override
  State<ChapterTile> createState() => _ChapterTileState();
}

class _ChapterTileState extends State<ChapterTile> {
  final GlobalKey imageGk = GlobalKey();
  final chapterController = Get.find<ChapterController>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => InterstitialAdWidget(
                adUnitId:
                    'ca-app-pub-4426001722546287/9726196914', // Substitua pelo seu ID de anúncio
                child: PageScreen(
                  chapterId: widget.chapter.id,
                  item: widget.item,
                  name: widget.chapter,
                )),
          ),
        );
        /* Get.to(() => PageScreen(
              chapterId: widget.chapter.id,
              item: widget.item,
              name: widget.chapter,
            ));*/
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          // Alterando de Stack para Column
          mainAxisSize: MainAxisSize
              .min, // Garante que a coluna encolha para caber no conteúdo
          children: [
            Image.network(
              widget.chapter.imagePath,
              key: imageGk,
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black.withOpacity(0.5),
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.index}° capítulo ${widget.chapter.title}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      bool? result =
                          await ShowOrderConfirmation.showOrderConfirmation(
                              context,
                              ' Todas as paginas deste capitulo serão selecionados comfirmar download do capitulo?',
                              'sim',
                              'não');
                      if (result ?? false) {
                        chapterController.downloadChapterContent(
                          widget.chapter.id,
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
      ),
    );
  }
}
