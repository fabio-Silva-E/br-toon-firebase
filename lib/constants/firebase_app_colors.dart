import 'package:flutter/material.dart';

class FirebaseAppColors {
  static final FirebaseAppColors _singleton = FirebaseAppColors._internal();

  factory FirebaseAppColors() {
    return _singleton;
  }

  FirebaseAppColors._internal();
  //black
  static Color get primaryColor => const Color(0xFF000000);
  //blue
  static Color get secondaryColors => const Color(0xFF2962ff);
  //red
  static Color get errorColor => const Color(0xFFdc3545);
  static Color get facvoriteColor => Colors.redAccent;
  //white
  static Color get whiteColor => const Color(0xFFFFFFFF);

  //green
  static Color get successColors => Colors.green;
}
