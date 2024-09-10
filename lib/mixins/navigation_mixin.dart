import 'package:flutter/material.dart';

mixin NavigationMixin {
  Future<void> handleNavigation(
    BuildContext context,
    String routeName, {
    bool clear = false,
    Object? arguments,
  }) {
    if (clear) {
      return Navigator.pushNamedAndRemoveUntil(
          context, routeName, (route) => false,
          arguments: arguments);
    }
    return Navigator.pushNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }
}
