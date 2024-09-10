import 'package:brtoon/constants/firebase_app_colors.dart';
import 'package:brtoon/common_widgets/text/widget_text.dart';
import 'package:flutter/material.dart';

enum MessageType { succes, error }

mixin SnackBarMixin {
  void showSnackBar(
      BuildContext context, String message, MessageType messageType) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: TextWidget.normal(message),
        backgroundColor: messageType == MessageType.error
            ? FirebaseAppColors.errorColor
            : FirebaseAppColors.successColors,
      ));
  }
}
