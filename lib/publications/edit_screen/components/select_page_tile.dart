import 'package:brtoon/common_widgets/interstitial_widget.dart';
import 'package:brtoon/common_widgets/showOrderConfirmation_widgest.dart';
import 'package:brtoon/models/page_chapter_model.dart';
import 'package:brtoon/publications/controller/editing_controller.dart';
import 'package:brtoon/publications/edit_screen/editi_page_tab.dart';
import 'package:brtoon/util_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectPageTile extends StatefulWidget {
  final String chapterId;
  final int index;
  const SelectPageTile({
    Key? key,
    required this.chapterId,
    required this.page,
    required this.index,
    // required this.chapter,
  }) : super(key: key);
  final PageModel page;

  @override
  State<SelectPageTile> createState() => _SelectPageTileState();
}

class _SelectPageTileState extends State<SelectPageTile> {
  final GlobalKey imageGk = GlobalKey();
  final editingControler = Get.find<EditingController>();
  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => InterstitialAdWidget(
                adUnitId:
                    'ca-app-pub-4426001722546287/9726196914', // Substitua pelo seu ID de anúncio
                child: EditingPageTab(
                  pageId: widget.page.id,
                  page: widget.page,
                )),
          ),
        );
        /* Get.to(() => EditingPageTab(
              pageId: widget.page.id,
              page: widget.page,
            ));*/
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.5),
        child: Column(
//crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '  ${widget.index}° pagina',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Image.network(
              widget.page.imagePath,
              key: imageGk,
              // fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 5,
              child: Obx(() => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.red, // Muda a cor de fundo para vermelho
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      bool? result =
                          await ShowOrderConfirmation.showOrderConfirmation(
                              context,
                              'Esta certo de que quer deletar esta pagina?',
                              'sim',
                              'não');
                      if (result ?? false) {
                        await editingControler.removePage(
                          widget.page.id,
                          widget.page.imagePath,
                        );
                      } else {
                        utilsServices.showToast(
                            message: 'Exclusão não concluída');
                      }
                    },
                    child: editingControler.isLoading.value
                        ? const CircularProgressIndicator()
                        : const Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                            size: 20,
                          ),
                  )),
            ),
          ],
          // Titulo
        ),
      ),
    );
  }
}
