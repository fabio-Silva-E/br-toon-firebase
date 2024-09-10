import 'package:brtoon/config/custom_colors.dart';
import 'package:brtoon/models/chapter_model.dart';
import 'package:brtoon/models/item_models.dart';
import 'package:brtoon/screens/components/page_tile.dart';
import 'package:brtoon/screens/screen/pages/controller/pages_controller.dart';
import 'package:brtoon/util_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageScreen extends StatefulWidget {
  final String chapterId;
  final HistoryModel item;
  final ChapterModel name;
  const PageScreen({
    Key? key,
    required this.chapterId,
    required this.item,
    required this.name,
  }) : super(key: key);

  @override
  State<PageScreen> createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  late bool _isLoading;
  final UtilsServices utilsServices = UtilsServices();
  final PagesController controller = Get.put(PagesController());

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    controller.setChapterId(widget.chapterId);
    _loadPages();
  }

  // Função para carregar as páginas de forma assíncrona
  Future<void> _loadPages() async {
    await controller.getAllPages();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.item.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: GetBuilder<PagesController>(
                    builder: (controller) {
                      if (controller.allPages.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 40,
                                color: CustomColors.customSwatchColor,
                              ),
                              const Text(
                                'Não há páginas postadas',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: controller.allPages.length,
                        itemBuilder: (_, index) {
                          return PageTile(
                            page: controller.allPages[index],
                            chapterId: widget.chapterId,
                            index: index + 1,
                            chapter: widget.name,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
