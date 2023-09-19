import 'package:camera_qr_project/app.dart';
import 'package:camera_qr_project/data/di.dart';
import 'package:camera_qr_project/domain/bloc/global/global_bloc_providers.dart';
import 'package:camera_qr_project/presentation/languages/app_languages.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await injectDependencies();

  runApp(
    GlobalBlocProviders(
      child: AppLanguages(
        child: App(),
      ),
    ),
  );
}
