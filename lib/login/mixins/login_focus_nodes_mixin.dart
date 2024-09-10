import 'package:flutter/material.dart';

mixin LoginFocusNodesMixin {
  final emailFN = FocusNode();
  final passwordFN = FocusNode();
  void disposeFN() {
    emailFN.dispose();
    passwordFN.dispose();
  }
}
