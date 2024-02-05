import 'package:flutter/material.dart';
import 'package:lesson20/ui/style/app_colors.dart';

abstract class AppStyle {
  static TextStyle fonstyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
    shadows: [
      Shadow(
        color: AppColors.black.withOpacity(0.25),
        offset: const Offset(4, 4),
        blurRadius: 20,
      )
    ],
  );
}