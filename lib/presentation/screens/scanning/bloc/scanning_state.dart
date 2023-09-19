import 'package:camera_qr_project/application/enums/screen_state_enum.dart';
import 'package:camera_qr_project/domain/entities/barcode/barcode_entity.dart';

enum CameraPermissionState {
  initial,
  granted,
  requireCameraPermission,
}

class ScanningState {
  ScreenState screenState;
  bool isCheckingPermission;
  String? value;
  bool isFlashOn;
  BarcodeEntity? barcodeEntity;
  CameraPermissionState cameraPermissionState;

  ScanningState({
    this.screenState = ScreenState.initial,
    this.isCheckingPermission = false,
    this.value,
    this.isFlashOn = false,
    this.barcodeEntity,
    this.cameraPermissionState = CameraPermissionState.initial,
  });

  ScanningState copyWith({
    ScreenState? screenState,
    bool? isCheckingPermission,
    String? value,
    bool? isFlashOn,
    BarcodeEntity? barcodeEntity,
    CameraPermissionState? cameraPermissionState,
  }) {
    return ScanningState(
      screenState: screenState ?? this.screenState,
      isCheckingPermission: isCheckingPermission ?? this.isCheckingPermission,
      value: value ?? this.value,
      isFlashOn: isFlashOn ?? this.isFlashOn,
      barcodeEntity: barcodeEntity ?? this.barcodeEntity,
      cameraPermissionState: cameraPermissionState ?? this.cameraPermissionState,
    );
  }
}
