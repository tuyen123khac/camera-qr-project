import 'package:camera_qr_project/presentation/languages/app_languages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const _appLocale = '_appLocale';

  static Future<void> setLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_appLocale, languageCode);
  }

  static Future<String> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_appLocale) ?? AppLanguages.deviceLocale.languageCode;
  }
}
