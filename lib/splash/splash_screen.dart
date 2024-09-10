import 'package:brtoon/firebase_auth/firebase_auth_service.dart';
import 'package:brtoon/splash/widget/splash_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  //static const String routeName = '/splash';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('SplashScreen loaded');
    return StreamProvider.value(
      value: FirebaseAuthService.getUserStream(context),
      initialData: null,
      child: const Scaffold(
        body: SplashScreenWidget(),
      ),
    );
  }
}
