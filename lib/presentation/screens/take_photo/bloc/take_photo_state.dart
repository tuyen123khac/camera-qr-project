import 'package:camera/camera.dart';

import 'package:camera_qr_project/application/enums/camera_enum.dart';

class TakePhotoState {
  CameraScreenState screenState;
  FlashMode flashMode;
  bool showFlashOptions;

  TakePhotoState({
    this.screenState = CameraScreenState.initial,
    this.flashMode = FlashMode.off,
    this.showFlashOptions = false,
  });

  TakePhotoState copyWith({
    CameraScreenState? screenState,
    FlashMode? flashMode,
    bool? showFlashOptions,
  }) {
    return TakePhotoState(
      screenState: screenState ?? this.screenState,
      flashMode: flashMode ?? this.flashMode,
      showFlashOptions: showFlashOptions ?? this.showFlashOptions,
    );
  }
}
