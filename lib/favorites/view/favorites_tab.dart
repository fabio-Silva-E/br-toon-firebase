import 'package:brtoon/common_widgets/anuncios_widget.dart';
import 'package:brtoon/common_widgets/category_tile.dart';
import 'package:brtoon/common_widgets/custom_shimmer.dart';
import 'package:brtoon/config/custom_colors.dart';
import 'package:brtoon/constants/firebase_app_colors.dart';
import 'package:brtoon/favorites/controller/favorietes_controller.dart';
import 'package:brtoon/favorites/view/components/favorites_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FirebaseAppColors.primaryColor,
        title: const Text(
          'Meus Favoritos',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            //campo de pesquisa
            GetBuilder<FavoritesController>(builder: (controller) {
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
            GetBuilder<FavoritesController>(
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
                          final category = controller.allCategories.firstWhere(
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
            GetBuilder<FavoritesController>(
              builder: (controller) {
                return Expanded(
                  child: !controller.isProductLoading
                      ? Visibility(
                          visible: (controller.currentCategory?.favorites ?? [])
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
                              print("itens ${controller.allProducts}");

                              return FavoritesTile(
                                favoritesHitory: controller.allProducts[index],
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
    );
  }
}
