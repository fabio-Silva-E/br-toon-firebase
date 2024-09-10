import 'package:brtoon/constants/firebase_app_colors.dart';
import 'package:flutter/material.dart';

class FirebaseAppTextStyles {
  static final FirebaseAppTextStyles _singleton =
      FirebaseAppTextStyles._internal();

  factory FirebaseAppTextStyles() {
    return _singleton;
  }

  FirebaseAppTextStyles._internal();

  static TextStyle get getNormalStyle =>
      TextStyle(color: FirebaseAppColors.whiteColor, fontSize: 14);

  static TextStyle get getNormalBoldStyle => getNormalStyle.copyWith(
        fontWeight: FontWeight.bold,
      );
  static TextStyle get getTitleStyle =>
      getNormalBoldStyle.copyWith(fontSize: 24);
  static TextStyle get getSmallStyle => getNormalStyle.copyWith(fontSize: 12);
}
