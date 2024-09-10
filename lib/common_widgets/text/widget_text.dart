import 'package:brtoon/constants/firebase_app_colors.dart';
import 'package:brtoon/constants/firebase_app_text_style.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final Color? color;
  final TextOverflow? overflow;
  const TextWidget(
    this.text, {
    required this.style,
    this.textAlign,
    this.color,
    this.overflow,
    super.key,
  });

  TextWidget.bold(
    this.text, {
    super.key,
    TextStyle? textStyle,
    this.textAlign,
    this.color,
    this.overflow,
  }) : style = textStyle ?? FirebaseAppTextStyles.getNormalBoldStyle;
  TextWidget.title(
    this.text, {
    super.key,
    TextStyle? textStyle,
    this.textAlign,
    this.color,
    this.overflow,
  }) : style = textStyle ?? FirebaseAppTextStyles.getTitleStyle;
  TextWidget.normal(
    this.text, {
    super.key,
    TextStyle? textStyle,
    this.textAlign,
    this.color,
    this.overflow,
  }) : style = textStyle ?? FirebaseAppTextStyles.getNormalStyle;
  TextWidget.small(
    this.text, {
    super.key,
    TextStyle? textStyle,
    this.textAlign,
    this.color,
    this.overflow,
  }) : style = textStyle ?? FirebaseAppTextStyles.getSmallStyle;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style.copyWith(
        color: color ?? FirebaseAppColors.whiteColor,
      ),
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}
