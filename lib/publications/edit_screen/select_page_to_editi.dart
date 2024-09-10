import 'package:brtoon/common_widgets/anuncios_widget.dart';
import 'package:brtoon/config/custom_colors.dart';
import 'package:brtoon/publications/controller/editing_controller.dart';
import 'package:brtoon/publications/edit_screen/components/select_page_tile.dart';
import 'package:brtoon/publications/screen/publish_pages_screen.dart';
import 'package:brtoon/screens/screen/pages/controller/pages_controller.dart';
import 'package:brtoon/util_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectPageToEditing extends StatefulWidget {
  final String chapterId;
  const SelectPageToEditing({
    Key? key,
    required this.chapterId,
  }) : super(key: key);

  @override
  State<SelectPageToEditing> createState() => _SelectPageToEditingState();
}

class _SelectPageToEditingState extends State<SelectPageToEditing> {
  final editing = EditingController();
  final UtilsServices utilsServices = UtilsServices();
  final PagesController controller = Get.put(PagesController());
  late bool _isLoading;
  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _loadPages(); // Chama a função que carrega os capítulos
  }

// Função para carregar os capítulos de forma assíncrona
  Future<void> _loadPages() async {
    // Aguarda a conclusão da operação assíncrona
    await controller.pages(widget.chapterId);
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
          'paginas',
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
                'selecione a pagina que dejesa editar',
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
      //  ),
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                // Lista de itens do carrinho
                Expanded(
                  child: GetBuilder<PagesController>(builder: (controller) {
                    if (controller.allPages.isEmpty) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 40,
                              color: CustomColors.customSwatchColor,
                            ),
                            const Text(
                              'Não a paginas postadas',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ]);
                    }
                    return ListView.builder(
                      itemCount: controller.allPages.length,
                      itemBuilder: (_, index) {
                        return SelectPageTile(
                          page: controller.allPages[index],
                          chapterId: widget.chapterId,
                          index: index + 1,
                          // page: widget.item,
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
                        Get.to(
                            () => PublishPageTab(chapterId: widget.chapterId));
                        // print(widget.item.id);
                      },
                      child: const Text(
                        'Adicionar pagina',
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
            ),
    );
  }
}
