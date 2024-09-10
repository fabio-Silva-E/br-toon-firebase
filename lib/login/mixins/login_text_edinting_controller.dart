import 'package:flutter/material.dart';

mixin LoginTextEditingControllerMixin {
  final emailTEC = TextEditingController();
  final passwordTEC = TextEditingController();
  void disposeLoginTECs() {
    emailTEC.dispose();
    passwordTEC.dispose();
  }
}
