import 'package:camera/camera.dart';
import 'package:camera_qr_project/application/enums/camera_enum.dart';
import 'package:camera_qr_project/presentation/screens/take_photo/bloc/take_photo_bloc.dart';
import 'package:camera_qr_project/presentation/screens/take_photo/bloc/take_photo_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitCameraSuccessListener extends BlocListener<TakePhotoBloc, TakePhotoState> {
  InitCameraSuccessListener({
    super.key,
    required super.listener,
  }) : super(
          listenWhen: (previousState, currentState) =>
              previousState.screenState != currentState.screenState &&
              currentState.screenState == CameraScreenState.initSuccess,
        );
}

class InitCameraFailedListener extends BlocListener<TakePhotoBloc, TakePhotoState> {
  InitCameraFailedListener({
    super.key,
    required super.listener,
  }) : super(
          listenWhen: (previousState, currentState) =>
              previousState.screenState != currentState.screenState &&
              currentState.screenState == CameraScreenState.initFailed,
        );
}

class InitCameraStatusSelector
    extends BlocSelector<TakePhotoBloc, TakePhotoState, CameraScreenState> {
  InitCameraStatusSelector({
    super.key,
    required Widget Function(CameraScreenState screenState) builder,
  }) : super(
          selector: (state) => state.screenState,
          builder: (_, screenState) => builder(screenState),
        );
}

class DisplayFlashOptionsSelector extends BlocSelector<TakePhotoBloc, TakePhotoState, bool> {
  DisplayFlashOptionsSelector({
    super.key,
    required Widget Function(bool isShowing) builder,
  }) : super(
          selector: (state) => state.showFlashOptions,
          builder: (_, isShowing) => builder(isShowing),
        );
}

class DisplayFlashModeSelector extends BlocSelector<TakePhotoBloc, TakePhotoState, FlashMode> {
  DisplayFlashModeSelector({
    super.key,
    required Widget Function(FlashMode flashMode) builder,
  }) : super(
          selector: (state) => state.flashMode,
          builder: (_, flashMode) => builder(flashMode),
        );
}
