import 'package:brtoon/base/controller/navigation_controller.dart';
import 'package:brtoon/config/custom_colors.dart';
import 'package:brtoon/favorites/view/favorites_tab.dart';
import 'package:brtoon/firebase_auth/firebase_auth_service.dart';
import 'package:brtoon/group_chats/Screens/UsersScreen.dart';
import 'package:brtoon/group_chats/controller/chat_controller.dart';
import 'package:brtoon/home/view/home_tab.dart';
import 'package:brtoon/pages_routes/app_pages.dart';
import 'package:brtoon/profile/perfil_screen.dart';
import 'package:brtoon/publish_screen/screen/publish_Screen.dart';
import 'package:brtoon/util_services.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final navigationController = Get.find<NavigationController>();
  final UtilsServices ultilsServices = UtilsServices();
  final ChatController chatController = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();
  }

  Map<String, bool> unreadNotifications = {
    'home': false,
    'profile': false,
  };

  void onLogout(BuildContext context) async {
    final String? error = await FirebaseAuthService.logout();
    if (error == null && context.mounted) {
      Get.offAllNamed(PagesRoutes.signInRoute);
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'fs27106@gmail.com', // Substitua pelo seu endereço de email
      query:
          'subject=Feedback&body=Escreva%20seu%20feedback%20aqui', // Tópico e corpo do email pré-definidos
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: _launchEmail,
              child: const Text(
                'Envie seu feedback',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // Mensagem e chave Pix no centro
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Ajude-me a manter o projeto ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'Chave Pix:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                        width: 5), // Espaçamento entre o texto e o ícone
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(const ClipboardData(
                            text: "834fa4bd-2979-493f-9184-3ceda49ee375"));
                        ultilsServices.showToast(message: 'Chave Pix copiada!');
                      },
                      child: Icon(
                        Icons.copy,
                        size: 16,
                        color: CustomColors.customSwatchColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => onLogout(context),
            icon: const Icon(
              Icons.exit_to_app_sharp,
              color: Colors.blue,
            ),
          ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: navigationController.pageController,
        children: [
          const HomeTab(),
          const FavoritesTab(),
          const PublishersTab(),
          const PerfilScreen(),
          UsersScreen(),
        ],
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: navigationController.currentIndex,
            onTap: (index) {
              navigationController.navigatePageview(index);
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.green,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withAlpha(100),
            items: [
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(Icons.home),
                    if (unreadNotifications['home']!)
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 8,
                            minHeight: 8,
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favoritos',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.library_books),
                label: 'suas publicações',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outlined),
                label: 'Perfil',
              ),
              BottomNavigationBarItem(
                icon: Obx(() {
                  return Stack(
                    children: [
                      const Icon(Icons.chat),
                      if (chatController.hasUnreadMessages.value)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                          ),
                        ),
                    ],
                  );
                }),
                label: 'Chat',
              ),
            ],
          )),
    );
  }
}
