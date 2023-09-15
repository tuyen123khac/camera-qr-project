import 'package:flutter/material.dart';

class AppColors {
  static Color tealPrimary = HexColor.fromHex('#1CBA92');
  static Color tealSecondary = HexColor.fromHex('#189F7D');
  static Color tealTertiary = HexColor.fromHex('#7DD7C0');
  static Color tealQuaternary = HexColor.fromHex('#DEF5EF');

  static Color error = HexColor.fromHex('#EC3D3D');
  static Color errorPrimary = HexColor.fromHex('#E12424');
  static Color errorSecondary = HexColor.fromHex('#FFC0C0');
  static Color errorTertiary = HexColor.fromHex('#FFF2F2');

  static Color bgDisable = HexColor.fromHex('#EAEDF1');
  static Color bgLight = HexColor.fromHex('#F5F7FA');
  static Color bgInput = HexColor.fromHex('#F1F5F8');

  static Color greyPrimary = HexColor.fromHex('#2F3845');
  static Color greySecondary = HexColor.fromHex('#444F66');
  static Color greyTertiary = HexColor.fromHex('#909FB3');

  static Color boxShadow = HexColor.fromHex('#F4F6FA');

  static Color white = HexColor.fromHex('#FFFFFF');
  static Color black = HexColor.fromHex('#000000');
}

extension HexColor on Color {
  static Color fromHex(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = "FF$hex"; // 8 char with opacity 100%
    }
    return Color(int.parse(hex, radix: 16));
  }
}
