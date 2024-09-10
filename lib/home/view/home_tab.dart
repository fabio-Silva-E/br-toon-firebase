import 'package:brtoon/common_widgets/anuncios_widget.dart';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:brtoon/base/controller/navigation_controller.dart';
import 'package:brtoon/common_widgets/app_name_widget.dart';
import 'package:brtoon/common_widgets/category_tile.dart';
import 'package:brtoon/common_widgets/custom_shimmer.dart';
import 'package:brtoon/config/custom_colors.dart';
import 'package:brtoon/favorites/controller/favorietes_controller.dart';
import 'package:brtoon/home/controller/home_controller.dart';
import 'package:brtoon/home/view/components/item_tile.dart';
import 'package:brtoon/util_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GlobalKey<CartIconKey> globalKeyFavoritesItems = GlobalKey<CartIconKey>();
  final searchController = TextEditingController();
  final navigationController = Get.find<NavigationController>();
  final favoritesController = Get.find<FavoritesController>();
  late Function(GlobalKey) runAddFavoritesAnimatios;

  void itemSelectedFavoritesAnimentinos(GlobalKey gkImage) {
    runAddFavoritesAnimatios(gkImage);

    ultilsServices.showToast(message: ' adicionado aos seus favoritos');
  }

  final UtilsServices ultilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return AddToCartAnimation(
      gkCart: globalKeyFavoritesItems,
      previewDuration: const Duration(milliseconds: 100),
      previewCurve: Curves.ease,
      receiveCreateAddToCardAnimationMethod: (addToCardAnimationMethod) {
        runAddFavoritesAnimatios = addToCardAnimationMethod;
      },
      child: Scaffold(
        //app bar
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Nome do aplicativo no lado esquerdo
              Row(
                children: [
                  Image.asset(
                    'assets/logo/imagem.png',
                    height: 50, // Altura da imagem
                    width: 50, // Largura da imagem
                  ),
                  const SizedBox(
                      width: 8), // Espaçamento entre a imagem e o nome
                  const AppNameWidget(),
                ],
              ),

              // Ícone de favoritos no lado direito
              Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                  right: 15,
                ),
                child: GetBuilder<FavoritesController>(
                  builder: (controller) {
                    return GestureDetector(
                      onTap: () {
                        navigationController
                            .navigatePageview(NavigationTabs.favorites);
                      },
                      child: StreamBuilder<int>(
                        stream: controller.getFavoritesCountStream(),
                        builder: (context, snapshot) {
                          int favoritesCount = snapshot.data ?? 0;
                          return Badge(
                            backgroundColor: CustomColors.redContrastColor,
                            label: Text(
                              '$favoritesCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            child: AddToCartIcon(
                              key: globalKeyFavoritesItems,
                              icon: Icon(
                                Icons.favorite,
                                color: CustomColors.customSwatchColor,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        body: Container(
          color: Colors.black,
          child: Column(
            children: [
              //campo de pesquisa
              GetBuilder<HomeController>(builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (value) {
                      controller.searchTitle.value = value;
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        hintText: 'pesquise aqui...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: CustomColors.redContrastColor,
                          size: 14,
                        ),
                        suffixIcon: controller.searchTitle.value.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  searchController.clear();
                                  controller.searchTitle.value = '';
                                  FocusScope.of(context).unfocus();
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: CustomColors.redContrastColor,
                                  size: 14,
                                ),
                              )
                            : null,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ))),
                  ),
                );
              }),

              //categorias
              GetBuilder<HomeController>(
                builder: (controller) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: CategoryDropdown(
                          categories: controller.allCategories
                              .map((cat) => cat.title)
                              .toList(),
                          selectedCategory:
                              controller.currentCategory?.title ?? '',
                          onCategoryChanged: (newCategory) {
                            // Find the category object by title
                            final category =
                                controller.allCategories.firstWhere(
                              (cat) => cat.title == newCategory,
                              orElse: () => controller.allCategories.first,
                            );
                            controller.selectCategory(category);
                          },
                        ),
                      ),
                      // Other widgets
                    ],
                  );
                },
              ),
              //grid
              GetBuilder<HomeController>(
                builder: (controller) {
                  return Expanded(
                    child: !controller.isProductLoading
                        ? Visibility(
                            visible: (controller.currentCategory?.history ?? [])
                                .isNotEmpty,
                            replacement: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 40,
                                  color: CustomColors.customSwatchColor,
                                ),
                                const Text(
                                  'Não  há historias a apresentar ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            child: GridView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 9 / 11.5,
                              ),
                              itemCount: controller.allProducts.length,
                              itemBuilder: (_, index) {
                                if ((index + 1) ==
                                    controller.allProducts.length) {
                                  if (((index + 1) ==
                                          controller.allProducts.length) &&
                                      !controller.isLastPage) {
                                    controller.loadMoreProducts();
                                  }
                                }

                                return ItemTile(
                                  item: controller.allProducts[index],
                                  favoritesAnimationMethod:
                                      itemSelectedFavoritesAnimentinos,
                                );
                              },
                            ),
                          )
                        : GridView.count(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            physics: const BouncingScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 9 / 11.5,
                            children: List.generate(
                              10,
                              (index) => CustomShimmer(
                                height: double.infinity,
                                width: double.infinity,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                  );
                },
              ),
              const AnunciosWidget(
                adUnitId: 'ca-app-pub-4426001722546287/1232629222',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
