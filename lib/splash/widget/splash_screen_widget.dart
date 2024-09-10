import 'package:brtoon/constants/assets_path_const.dart';
import 'package:brtoon/firebase_auth/firebase_auth_service.dart';
import 'package:brtoon/pages_routes/app_pages.dart';
import 'package:brtoon/common_widgets/sized_box/sized_box_widget.dart';
import 'package:brtoon/common_widgets/text/widget_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({super.key});

  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 2));
      final user = FirebaseAuthService.getUser;
      if (context.mounted) {
        if (user == null) {
          Get.offAllNamed(PagesRoutes.signInRoute);
        } else {
          Get.offAllNamed(PagesRoutes.baseRoute);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Lottie.asset(AssetsPathConst.animationSplash),
          ),
          const SizedBoxWidget.md(),
          TextWidget.title('carregando....')
        ],
      ),
    );
  }
}
