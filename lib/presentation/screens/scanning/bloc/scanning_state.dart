import 'package:camera_qr_project/domain/barcode/barcode_entity.dart';

enum ScreenState {
  initial,
  loading,
  success,
  failed,
}

class ScanningState {
  ScreenState screenState;
  String? value;
  bool isFlashOn;
  BarcodeEntity? barcodeEntity;

  ScanningState({
    this.screenState = ScreenState.initial,
    this.value,
    this.isFlashOn = false,
    this.barcodeEntity,
  });

  ScanningState copyWith({
    ScreenState? screenState,
    String? value,
    bool? isFlashOn,
    BarcodeEntity? barcodeEntity,
  }) {
    return ScanningState(
      screenState: screenState ?? this.screenState,
      value: value ?? this.value,
      isFlashOn: isFlashOn ?? this.isFlashOn,
      barcodeEntity: barcodeEntity ?? this.barcodeEntity,
    );
  }
}
