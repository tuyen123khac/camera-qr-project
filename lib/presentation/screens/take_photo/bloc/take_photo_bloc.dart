import 'package:camera/camera.dart';
import 'package:camera_qr_project/application/enums/camera_enum.dart';
import 'package:camera_qr_project/presentation/screens/take_photo/bloc/take_photo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TakePhotoBloc extends Cubit<TakePhotoState> {
  TakePhotoBloc() : super(TakePhotoState());

  void onInitCamera() {
    emit(state.copyWith(screenState: CameraScreenState.initial));
  }

  void onInitCameraFailed() {
    emit(state.copyWith(screenState: CameraScreenState.initFailed));
  }

  void onInitCameraSuccess() {
    emit(state.copyWith(screenState: CameraScreenState.initSuccess));
  }

  void setFlashMode(FlashMode flashMode) {
    emit(state.copyWith(flashMode: flashMode, showFlashOptions: false));
  }

  void toggleFlashOptions() {
    emit(state.copyWith(showFlashOptions: !state.showFlashOptions));
  }
}
