import 'package:camera_qr_project/data/local/shared_prefs.dart';
import 'package:camera_qr_project/domain/bloc/global/global_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalBloc extends Cubit<GlobalState> {
  GlobalBloc({
    required Locale locale,
  }) : super(
          GlobalState(locale: locale),
        );

  void changeLocale(Locale locale) {
    emit(state.copyWith(locale: locale));
    SharedPrefs.setLocale(locale.languageCode);
  }
}
