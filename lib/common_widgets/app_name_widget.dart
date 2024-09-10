import 'package:brtoon/config/custom_colors.dart';
import 'package:flutter/material.dart';

class AppNameWidget extends StatelessWidget {
  final Color? brasilTileColor;
  final double textSize;
  const AppNameWidget({
    super.key,
    this.brasilTileColor,
    this.textSize = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontSize: textSize,
        ),
        children: [
          TextSpan(
            text: 'Br',
            style: TextStyle(
              color: brasilTileColor ?? CustomColors.customSwatchColor,
            ),
          ),
          TextSpan(
            text: 'toon',
            style: TextStyle(
              color: CustomColors.customContrastColor,
            ),
          ),
        ],
      ),
    );
  }
}
