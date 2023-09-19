import 'package:camera_qr_project/domain/entities/barcode/barcode_wifi_entity.dart';
import 'package:camera_qr_project/presentation/languages/translation_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class StringUtils {
  static String maskPassword(String? password) {
    if (password == null) {
      return tr(LocaleKeys.NoPassword);
    }

    // Get the first and last characters of the password
    String firstChar = password.substring(0, 1);
    String lastChar = password.substring(password.length - 1);

    // Create a mask of asterisks (*) with the same length as the middle characters
    String middleMask = '*' * (password.length - 2);

    // Concatenate the first character, middle mask, and last character
    return '$firstChar$middleMask$lastChar';
  }

  static bool isWifiQrCode(String? code) {
    if (code == null) return false;

    return code.contains('WIFI');
  }

  static bool isUrlQrCode(String? code) {
    if (code == null) return false;

    return code.contains('http');
  }

  static getBarcodeWifiEntity(String? code) {
    if (code == null) return BarcodeWifiEntity();

    String? ssid;
    String? password;
    List<String> components = code.split(';');

    for (String component in components) {
      if (component.startsWith("WIFI:S:")) {
        // Found SSID component
        ssid = component.substring(7); // Extract the SSID value
      } else if (component.startsWith("P:")) {
        // Found password component
        password = component.substring(2); // Extract the password value
      }
    }

    return BarcodeWifiEntity(ssid: ssid, password: password);
  }
}
