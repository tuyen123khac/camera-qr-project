import 'package:camera_qr_project/presentation/screens/scanning/bloc/scanning_bloc.dart';
import 'package:camera_qr_project/presentation/screens/scanning/bloc/scanning_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScanningScreenStateSuccessListener extends BlocListener<ScanningBloc, ScanningState> {
  ScanningScreenStateSuccessListener({
    super.key,
    required super.listener,
  }) : super(
          listenWhen: (previousState, currentState) =>
              previousState.screenState != currentState.screenState &&
              currentState.screenState == ScreenState.success &&
              currentState.barcodeEntity != null,
        );
}

class ScanningScreenStateFailedListener extends BlocListener<ScanningBloc, ScanningState> {
  ScanningScreenStateFailedListener({
    super.key,
    required super.listener,
  }) : super(
          listenWhen: (previousState, currentState) =>
              previousState.screenState != currentState.screenState &&
              currentState.screenState == ScreenState.failed,
        );
}

class ScanningScreenStateLoadingSelector extends BlocSelector<ScanningBloc, ScanningState, bool> {
  ScanningScreenStateLoadingSelector({
    super.key,
    required Widget Function(bool isLoading) builder,
  }) : super(
          selector: (state) => state.screenState == ScreenState.loading,
          builder: (_, isLoading) => builder(isLoading),
        );
}
