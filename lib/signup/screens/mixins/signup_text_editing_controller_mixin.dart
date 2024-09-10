import 'package:flutter/material.dart';

mixin SignupTextEditingControllerMixin {
  final emailTEC = TextEditingController();
  final passwordTEC = TextEditingController();
  final nameTEC = TextEditingController();
  final phoneTEC = TextEditingController();
  void disposeTECs() {
    emailTEC.dispose();
    passwordTEC.dispose();
    nameTEC.dispose();
    phoneTEC.dispose();
  }
}
