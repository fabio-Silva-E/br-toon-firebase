import 'package:brtoon/common_widgets/card_widgest.dart';
import 'package:brtoon/common_widgets/interstitial_widget.dart';
import 'package:brtoon/common_widgets/showOrderConfirmation_widgest.dart';
import 'package:brtoon/config/custom_colors.dart';
import 'package:brtoon/constants/border_radius.dart';
import 'package:brtoon/models/item_models.dart';
import 'package:brtoon/publications/edit_screen/editi_cover_tab.dart';
import 'package:brtoon/publish_screen/controller/publish_history.dart';
import 'package:brtoon/screens/chapter_screen.dart';
import 'package:brtoon/util_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';

class PublishersTile extends StatefulWidget {
  final HistoryModel publishersItem;
  const PublishersTile({
    super.key,
    required this.publishersItem,
  });

  @override
  State<PublishersTile> createState() => _PublishersTileState();
}

class _PublishersTileState extends State<PublishersTile> {
  final GlobalKey imageGk = GlobalKey();
  final UtilsServices ultilsServices = UtilsServices();
  final controller = Get.find<PublishHistoryController>();
  // final editingControler = Get.find<EditingController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => ChapterScreen(
                  historyId: widget.publishersItem.id, // Passa o ID do produto
                  item: widget.publishersItem,
                ));
          },
          child: CustomCardWidget(
            imageUrl: widget.publishersItem.imagePath,
            itemName: widget.publishersItem.title,
            historyId: widget.publishersItem.id,
          ),
        ),
        //botão excluir
        Positioned(
          top: 4,
          left: 4,
          child: GestureDetector(
            onTap: () async {
              bool? result = await ShowOrderConfirmation.showOrderConfirmation(
                  context,
                  'Esta ação ira excluir totalmente sua historia esta certo de que quér fazer isto?',
                  'sim',
                  'não');
              if (result ?? false) {
                await controller.removePublishedHistory(
                  historyId: widget.publishersItem.id,
                );
              } else {
                ultilsServices.showToast(
                  message: 'Atualização não concluida',
                );
              }
            },
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(Border_Radius.circular),
              ),
              child: const Icon(
                Icons.delete_forever,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        //botão editar
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () async {
              /*  bool? result = await ShowOrderConfirmation.showOrderConfirmation(
                  context,
                  'Sera usado moedas de sua carteira Brasiltoon para as proximas ações',
                  'continuar ?',
                  'sair');
              if (result ?? false) {*/
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => InterstitialAdWidget(
                      adUnitId:
                          'ca-app-pub-4426001722546287/9726196914', // Substitua pelo seu ID de anúncio
                      child: EditingCapeTab(
                        productId:
                            widget.publishersItem.id, // Passa o ID do produto
                        item: widget.publishersItem,
                        category: controller.currentCategory!.id,
                      )),
                ),
              );
              /*  Get.to(() => EditingCapeTab(
                    productId:
                        widget.publishersItem.id, // Passa o ID do produto
                    item: widget.publishersItem,
                    category: controller.currentCategory!.id,
                  ));*/
              //   }
            },
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: CustomColors.customSwatchColor,
                borderRadius: BorderRadius.circular(Border_Radius.circular),
              ),
              child: const Icon(
                PhosphorIcons.pencil,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ), // OBS CRIAR UMA FUNÇÃO PARA EDIÇÃO DA HISTORIA
      ],
    );
  }
}
