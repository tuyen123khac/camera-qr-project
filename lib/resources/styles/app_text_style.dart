
import 'package:camera_qr_project/resources/fonts/app_font.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle regular({
    double fontSize = 16.0,
    required Color color,
    String fontFamily = AppFontFamily.fontFamilyMulish,
    double? lineHeight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: AppFontWeight.regular,
      color: color,
      height: lineHeight != null ? lineHeight / fontSize : null,
    );
  }

  static TextStyle medium({
    double fontSize = 16.0,
    required Color color,
    String fontFamily = AppFontFamily.fontFamilyMulish,
    double? lineHeight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: AppFontWeight.medium,
      color: color,
      height: lineHeight != null ? lineHeight / fontSize : null,
    );
  }

  static TextStyle bold({
    double fontSize = 18.0,
    required Color color,
    String fontFamily = AppFontFamily.fontFamilyMulish,
    double? lineHeight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: AppFontWeight.bold,
      color: color,
      height: lineHeight != null ? lineHeight / fontSize : null,
    );
  }
}
