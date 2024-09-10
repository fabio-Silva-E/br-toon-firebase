import 'package:brtoon/common_widgets/anuncios_widget.dart';
import 'package:brtoon/config/custom_colors.dart';
import 'package:brtoon/publications/edit_screen/components/select_chapter_tile.dart';
import 'package:brtoon/publications/screen/publish_Chapter_screen.dart';
import 'package:brtoon/screens/screen/chapters/controller/chapter_controller.dart';
import 'package:brtoon/util_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectChapterToEditing extends StatefulWidget {
  final String productId;
  const SelectChapterToEditing({
    Key? key,
    required this.productId,
    // required this.item,
  }) : super(key: key);
  // final ItemModel item;
  @override
  State<SelectChapterToEditing> createState() => _SelectChapterToEditingState();
}

class _SelectChapterToEditingState extends State<SelectChapterToEditing> {
  late bool _isLoading;
  final UtilsServices utilsServices = UtilsServices();
  final ChapterController controller = Get.put(ChapterController());

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _loadChapters(); // Chama a função que carrega os capítulos
  }

// Função para carregar os capítulos de forma assíncrona
  Future<void> _loadChapters() async {
    // Aguarda a conclusão da operação assíncrona
    await controller.chapters(widget.productId);
    setState(() {
      _isLoading = false;
    });
    // Após a conclusão, você pode imprimir os capítulos
    //print('Capítulos carregados: ${controller.allChapters}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Capitulos',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(16), // Ajuste conforme necessário

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'selecione o capitulo que dejesa editar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.black,
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Lista de itens do carrinho
                  Expanded(
                    child: GetBuilder<ChapterController>(builder: (controller) {
                      if (controller.allChapters.isEmpty) {
                        return Column(children: [
                          Icon(
                            Icons.search_off,
                            size: 40,
                            color: CustomColors.customSwatchColor,
                          ),
                          const Text(
                            'Não a capitulos postados',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ]);
                      }
                      return ListView.builder(
                        itemCount: controller.allChapters.length,
                        itemBuilder: (_, index) {
                          return SelectChapterTile(
                            chapter: controller.allChapters[index],
                            productId: widget.productId,
                            //  item: widget.item,
                            index: index + 1,
                          );
                        },
                      );
                    }),
                  ),

                  const SizedBox(height: 10),
                  Center(
                    child: SizedBox(
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.customSwatchColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async {
                          Get.to(() => PublishChapterTab(
                                historyId: widget.productId,
                              ));
                          // print(widget.item.id);
                        },
                        child: const Text(
                          'Adicionar capitulo',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const AnunciosWidget(
                    adUnitId: 'ca-app-pub-4426001722546287/1232629222',
                  ),
                ],
              ));
  }
}
