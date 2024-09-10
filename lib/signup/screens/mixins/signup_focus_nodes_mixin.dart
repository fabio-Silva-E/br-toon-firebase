import 'package:flutter/material.dart';

mixin SignupFocusNodesMixin {
  final emailFN = FocusNode();
  final passwordFN = FocusNode();
  final nameFN = FocusNode();
  final phoneFN = FocusNode();
  void disposeFN() {
    emailFN.dispose();
    passwordFN.dispose();
    nameFN.dispose();
    phoneFN.dispose();
  }
}
