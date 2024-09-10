import 'package:brtoon/common_widgets/card_widgest.dart';
import 'package:brtoon/common_widgets/interstitial_widget.dart';
import 'package:brtoon/common_widgets/showOrderConfirmation_widgest.dart';
import 'package:brtoon/config/custom_colors.dart';
import 'package:brtoon/constants/border_radius.dart';
import 'package:brtoon/favorites/controller/favorietes_controller.dart';
import 'package:brtoon/models/favorite_history_model.dart';
import 'package:brtoon/screens/chapter_screen.dart';
import 'package:brtoon/util_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesTile extends StatefulWidget {
  final FavoriteHistoryModel favoritesHitory;

  const FavoritesTile({
    super.key,
    required this.favoritesHitory,
  });

  @override
  State<FavoritesTile> createState() => _FavoritesTileState();
}

class _FavoritesTileState extends State<FavoritesTile> {
  final UtilsServices ultilsServices = UtilsServices();
  final controller = Get.find<FavoritesController>();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => InterstitialAdWidget(
                  adUnitId:
                      'ca-app-pub-4426001722546287/9726196914', // Substitua pelo seu ID de anúncio
                  child: ChapterScreen(
                    historyId: widget.favoritesHitory.history.id,
                    item: widget.favoritesHitory.history,
                  ),
                ),
              ),
            );
            /* Get.to(() => ChapterScreen(
                  historyId: widget.favoritesHitory.history.id,
                  item: widget.favoritesHitory.history,
                ));*/
          },
          child: CustomCardWidget(
            imageUrl: widget.favoritesHitory.history.imagePath,
            itemName: widget.favoritesHitory.history.title,
            historyId: widget.favoritesHitory.history.id,
          ),
        ),
        //botão desfavoritar
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () async {
              // Mostra a caixa de diálogo de confirmação
              bool? confirmation =
                  await ShowOrderConfirmation.showOrderConfirmation(
                      context,
                      'Deseja realmente desfavoritar este conteudo',
                      'sim',
                      'não');
              if (confirmation == true) {
                // Chama a função remove apenas se a confirmação for verdadeira
                setState(() {
                  controller.removeItemFromFavorites(
                      item: widget.favoritesHitory);
                });
              }
            },
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: CustomColors.customSwatchColor,
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
      ],
    );
  }
}
