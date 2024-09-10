import 'package:brtoon/common_widgets/anuncios_widget.dart';
import 'package:brtoon/common_widgets/category_tile.dart';
import 'package:brtoon/common_widgets/custom_shimmer.dart';
import 'package:brtoon/common_widgets/interstitial_widget.dart';
import 'package:brtoon/config/custom_colors.dart';
import 'package:brtoon/publications/screen/publish_histori_screen.dart';
import 'package:brtoon/publish_screen/controller/publish_history.dart';
import 'package:brtoon/publish_screen/screen/components/publishers_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PublishersTab extends StatefulWidget {
  const PublishersTab({super.key});

  @override
  State<PublishersTab> createState() => _PublishersTabState();
}

class _PublishersTabState extends State<PublishersTab> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Suas Publicações',
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
            // Campo de pesquisa
            GetBuilder<PublishHistoryController>(
              builder: (controller) {
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
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            // Categorias
            GetBuilder<PublishHistoryController>(
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
            GetBuilder<PublishHistoryController>(
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
                                'Não há histórias para apresentar',
                                style: TextStyle(
                                  fontSize: 12,
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
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    controller.loadMoreProducts();
                                  });
                                }
                              }
                              return PublishersTile(
                                publishersItem: controller.allProducts[index],
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
            // Publicar história
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    try {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const InterstitialAdWidget(
                              adUnitId:
                                  'ca-app-pub-4426001722546287/9726196914', // Substitua pelo seu ID de anúncio
                              child: PublishCapeHistoryTab()),
                        ),
                      );
                      //  Get.to(() => const PublishCapeHistoryTab());
                    } catch (e) {
                      print('Erro ao navegar para PublishCapeHistoryTab: $e');
                    }
                  });
                },
                child: const Text(
                  'Publicar história',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
