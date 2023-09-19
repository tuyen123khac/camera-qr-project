import 'dart:io';

import 'package:camera_qr_project/domain/bloc/global/global_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppLanguage {
  final Locale locale;
  final String name;
  final String flag;

  const AppLanguage({
    required this.locale,
    required this.name,
    required this.flag,
  });
}

class AppLanguages extends StatelessWidget {
  static const String translationsPath = 'lib/presentation/languages/translations';

  static final List<AppLanguage> supportedLanguages = [
    const AppLanguage(
      flag: '🇬🇧',
      locale: Locale('en'),
      name: 'English',
    ),
    const AppLanguage(
      flag: '🇻🇳',
      locale: Locale('vi'),
      name: 'Tiếng Việt',
    ),
  ];

  static final List<Locale> supportedLocales = supportedLanguages.map((e) => e.locale).toList();
  static final AppLanguage fallbackLanguage = supportedLanguages.first;

  static Locale get deviceLocale {
    final supportedLanguageCodes = supportedLanguages.map((e) => e.locale.languageCode);

    final languageCode = Platform.localeName.split('_').firstWhere(
          (element) => supportedLanguageCodes.contains(element),
          orElse: () => fallbackLanguage.locale.languageCode,
        );

    return Locale(languageCode);
  }

  static AppLanguage parseLanguage(String? languageCode) {
    return supportedLanguages.firstWhere(
      (element) => element.locale.languageCode == languageCode,
      orElse: () => supportedLanguages.first,
    );
  }

  final Widget child;

  const AppLanguages({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      path: translationsPath,
      supportedLocales: supportedLocales,
      fallbackLocale: fallbackLanguage.locale,
      saveLocale: true,
      startLocale: context.read<GlobalBloc>().state.locale,
      child: child,
    );
  }
}
