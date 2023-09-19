import 'package:camera_qr_project/data/local/shared_prefs.dart';
import 'package:camera_qr_project/domain/bloc/global/global_bloc.dart';
import 'package:camera_qr_project/presentation/languages/app_languages.dart';
import 'package:camera_qr_project/presentation/screens/scanning/bloc/scanning_bloc.dart';
import 'package:camera_qr_project/presentation/screens/take_photo/bloc/take_photo_bloc.dart';
import 'package:get_it/get_it.dart';

final provider = GetIt.instance;

Future<void> injectDependencies() async {
  _registerBlocs();
}

Future<void> _registerBlocs() async {
  provider.registerFactory<ScanningBloc>(() => ScanningBloc());
  provider.registerFactory<TakePhotoBloc>(() => TakePhotoBloc());
  provider.registerSingleton<GlobalBloc>(
    GlobalBloc(
      locale: await SharedPrefs.getLocale()
          .then(AppLanguages.parseLanguage)
          .then((value) => value.locale),
    ),
  );
}
