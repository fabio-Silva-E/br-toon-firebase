import 'package:brtoon/firebase_auth/firebase_auth_service.dart';
import 'package:flutter/material.dart';

class LoginController {
  final loginFormKey = GlobalKey<FormState>();
  Future<String?> onLogin(String email, String password) async {
    if (loginFormKey.currentState!.validate()) {
      final String? error = await FirebaseAuthService.login(email, password);
      if (error != null) {
        return "email ou senha invalidos";
      }
      return null;
    }
    return 'Formulario invalido';
  }
}
