import 'package:brtoon/common_widgets/card_widgest.dart';
import 'package:brtoon/common_widgets/interstitial_widget.dart';
import 'package:brtoon/common_widgets/like_button.dart';
import 'package:brtoon/common_widgets/showOrderConfirmation_widgest.dart';
import 'package:brtoon/config/custom_colors.dart';
import 'package:brtoon/constants/border_radius.dart';
import 'package:brtoon/favorites/controller/favorietes_controller.dart';
import 'package:brtoon/home/controller/home_controller.dart';
import 'package:brtoon/likes/controller/like_controller.dart';
import 'package:brtoon/models/item_models.dart';
import 'package:brtoon/profile/author_profile.dart';
import 'package:brtoon/screens/chapter_screen.dart';
import 'package:brtoon/util_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemTile extends StatefulWidget {
  final HistoryModel item;
  final void Function(GlobalKey) favoritesAnimationMethod;
  // final bool follow;
  const ItemTile({
    Key? key,
    required this.item,
    required this.favoritesAnimationMethod,
    // required this.follow,
  }) : super(key: key);

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  final GlobalKey imageGk = GlobalKey();
  late void Function(GlobalKey) favoritesAnimationMethod;
  late bool isFavorite;

  // final authController = Get.find<AuthController>();
  bool isCheckingFavorite = true;
  bool showFavoriteButton = false;
  final LikeController likeController =
      Get.put(LikeController()); // Mova o controlador aqui
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UtilsServices utilServices = UtilsServices();
  final favoritesController = Get.find<FavoritesController>();
  IconData tileIcon = Icons.library_add;
  final homeController = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();
    _checkIsFavorite();

    _initializeLikeController(); // Inicializa o controlador de like
  }

  Future<void> _initializeLikeController() async {
    User? user = _firebaseAuth.currentUser;
    await likeController.checkLikeStatus(widget.item.id, user!.uid);
    await likeController.getLikeCount(widget.item.id);
  }

  @override
  void didUpdateWidget(ItemTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item != oldWidget.item) {
      _checkIsFavorite();
      //   _initializeLikeController(); // Atualiza o controlador de like
    }
  }

  Future<void> _checkIsFavorite() async {
    setState(() {
      isCheckingFavorite = true;
    });

    bool isItemFavorite = await favoritesController.isItemFavorite(widget.item);

    setState(() {
      isFavorite = true;
      isCheckingFavorite = false;
      showFavoriteButton = !isItemFavorite;
    });
  }

  Future<void> switchIcon() async {
    setState(() => tileIcon = isFavorite ? Icons.library_add : Icons.check);
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() => tileIcon = Icons.library_add);
  }

  Future<void> _addToFavorites(HistoryModel item) async {
    setState(() {
      isCheckingFavorite = true;
    });

    await favoritesController.addItemToFavorites(item: item);

    setState(() {
      isFavorite = true;
      isCheckingFavorite = false;
      showFavoriteButton = false;
    });

    widget.favoritesAnimationMethod(imageGk);
  }

  @override
  Widget build(BuildContext context) {
    User? user = _firebaseAuth.currentUser;
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
                    historyId: widget.item.id,
                    item: widget.item,
                  ),
                ),
              ),
            );
          },

          /* onTap: () {
            Get.to(() => ChapterScreen(
                  historyId: widget.item.id,
                  item: widget.item,
                ));
          },*/
          child: CustomCardWidget(
            imageUrl: widget.item.imagePath,
            itemName: widget.item.title,
            imageGk: imageGk,
            historyId: widget.item.id,
          ),
        ),
        if (showFavoriteButton)
          Positioned(
            top: 4,
            right: 4,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Border_Radius.circular),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        switchIcon();
                        _addToFavorites(widget.item);
                      },
                      child: Ink(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: CustomColors.customSwatchColor,
                        ),
                        child: Icon(
                          tileIcon,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                if (isCheckingFavorite)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(Border_Radius.bottomLeft),
                          topRight: Radius.circular(Border_Radius.topRight),
                        ),
                        color:
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        //likes da historia
        Positioned(
          bottom: 65,
          right: 4,
          child: Container(
            height: 35,
            constraints: const BoxConstraints(maxWidth: 200), // Max width
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: CustomColors.customSwatchColor,
              borderRadius: BorderRadius.circular(Border_Radius.circular),
            ),
            child: LikeButton(post: widget.item.id, userId: user!.uid),
          ),
        ),
        //perfil do editor
        if (widget.item.userId != null)
          Positioned(
            bottom: 65,
            left: 4,
            child: GestureDetector(
              onTap: () async {
                Get.to(() => PerfilTab(
                      userId: widget.item.userId!,
                      // follow: widget.follow,
                    ));
              },
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: CustomColors.customSwatchColor,
                  borderRadius: BorderRadius.circular(Border_Radius.circular),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        Positioned(
          top: 4,
          left: 4,
          child: GestureDetector(
            onTap: () async {
              bool? result = await ShowOrderConfirmation.showOrderConfirmation(
                context,
                'Todos os capítulos e páginas desta história serão selecionados. Confirmar download?',
                'Sim',
                'Não',
              );
              if (result ?? false) {
                homeController.downloadHistoryContent(
                  widget.item.id,
                );
              }
            },
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(Border_Radius.circular),
              ),
              child: const Icon(
                Icons.file_download,
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
