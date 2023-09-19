import 'dart:io';

import 'package:camera_qr_project/application/enums/screen_state_enum.dart';
import 'package:camera_qr_project/application/utils/permission_util.dart';
import 'package:camera_qr_project/application/utils/string_util.dart';
import 'package:camera_qr_project/domain/entities/barcode/barcode_url_entity.dart';
import 'package:camera_qr_project/domain/entities/barcode/barcode_wifi_entity.dart';
import 'package:camera_qr_project/presentation/screens/scanning/bloc/scanning_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart' as qr;

class ScanningBloc extends Cubit<ScanningState> {
  ScanningBloc() : super(ScanningState());
  var isCameraPermissionChecked = false;
  final ImagePicker _picker = ImagePicker();

  void handlePermission() async {
    final cameraPermission = await PermissionUtil.checkCameraPermission();

    switch (cameraPermission) {
      case PermissionStatus.granted:
        _onCameraPermissionGranted();
        break;
      case PermissionStatus.denied:
        _onCameraPermissionDenied();
        break;
      case PermissionStatus.permanentlyDenied:
        _onCameraPermissionPermanentlyDenied();
        break;
      default:
    }
  }

  void _onCameraPermissionGranted() {
    emit(state.copyWith(cameraPermissionState: CameraPermissionState.granted));
  }

  void _onCameraPermissionDenied() {
    if (!isCameraPermissionChecked) {
      PermissionUtil.requestCameraPermission();
      isCameraPermissionChecked = true;
      return;
    }
    emit(state.copyWith(cameraPermissionState: CameraPermissionState.requireCameraPermission));
  }

  void _onCameraPermissionPermanentlyDenied() {
    if (Platform.isIOS) {
      emit(state.copyWith(cameraPermissionState: CameraPermissionState.requireCameraPermission));
    }

    if (!isCameraPermissionChecked) {
      PermissionUtil.requestCameraPermission();
      isCameraPermissionChecked = true;
      return;
    }
    emit(state.copyWith(cameraPermissionState: CameraPermissionState.requireCameraPermission));
  }

  void initFlashState(bool value) {
    emit(state.copyWith(isFlashOn: value));
  }

  void toggleFlash() {
    emit(state.copyWith(isFlashOn: !state.isFlashOn));
  }

  Future<String?> getImportedImagePath() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      return image?.path;
    } catch (e) {
      return null;
    }
  }

  Future<void> getBarcodeValues() async {
    try {
      emit(state.copyWith(screenState: ScreenState.loading));

      final image = await _picker.pickImage(source: ImageSource.gallery);

      final imagePath = image?.path;
      final inputImage = InputImage.fromFilePath(imagePath!);

      final barcodeScanner = BarcodeScanner();
      final barcodes = await barcodeScanner.processImage(inputImage);

      if (barcodes.isEmpty) {
        emit(state.copyWith(screenState: ScreenState.failed));
      }

      for (var barcode in barcodes) {
        // Demo Wifi & URL type only
        switch (barcode.type) {
          case BarcodeType.wifi:
            final barcodeWifi = (barcode.value as BarcodeWifi);
            emit(state.copyWith(
              screenState: ScreenState.success,
              barcodeEntity: BarcodeWifiEntity(
                ssid: barcodeWifi.ssid,
                password: StringUtils.maskPassword(barcodeWifi.password),
              ),
            ));
            break;
          case BarcodeType.url:
            final barcodeUrl = (barcode.value as BarcodeUrl);
            emit(state.copyWith(
              screenState: ScreenState.success,
              barcodeEntity: BarcodeUrlEntity(
                title: barcodeUrl.title,
                url: barcodeUrl.url,
              ),
            ));
            break;
          default:
            emit(state.copyWith(screenState: ScreenState.failed));
        }
      }
    } catch (e) {
      emit(state.copyWith(screenState: ScreenState.failed));
    }
  }

  void onScanSuccess(qr.Barcode scanData) {
    emit(state.copyWith(screenState: ScreenState.loading));

    final data = scanData.code;

    if (StringUtils.isUrlQrCode(data)) {
      emit(state.copyWith(
        screenState: ScreenState.success,
        barcodeEntity: BarcodeUrlEntity(
          url: data,
        ),
      ));

      return;
    }

    if (StringUtils.isWifiQrCode(data)) {
      emit(state.copyWith(
        screenState: ScreenState.success,
        barcodeEntity: StringUtils.getBarcodeWifiEntity(data),
      ));

      return;
    }

    emit(state.copyWith(screenState: ScreenState.failed));
  }

  void onScanError() {
    emit(state.copyWith(screenState: ScreenState.loading));
    emit(state.copyWith(screenState: ScreenState.failed));
  }
}
