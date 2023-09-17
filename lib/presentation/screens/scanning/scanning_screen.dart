import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:camera_qr_project/data/di.dart';
import 'package:camera_qr_project/domain/barcode/barcode_entity.dart';
import 'package:camera_qr_project/domain/barcode/barcode_url_entity.dart';
import 'package:camera_qr_project/domain/barcode/barcode_wifi_entity.dart';
import 'package:camera_qr_project/presentation/screens/scanning/bloc/scanning_bloc.dart';
import 'package:camera_qr_project/presentation/screens/scanning/bloc/scanning_selector.dart';
import 'package:camera_qr_project/presentation/screens/scanning/bloc/scanning_state.dart';
import 'package:camera_qr_project/presentation/widgets/buttons/image_button.dart';
import 'package:camera_qr_project/presentation/widgets/dialogs/app_base_dialog.dart';
import 'package:camera_qr_project/resources/colors/app_colors.dart';
import 'package:camera_qr_project/resources/images/app_images.dart';
import 'package:camera_qr_project/resources/languages/translation_keys.g.dart';
import 'package:camera_qr_project/resources/styles/app_text_style.dart';
import 'package:camera_qr_project/resources/values/app_values.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart' as qr;

@RoutePage()
class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> {
  final ScanningBloc _bloc = provider.get<ScanningBloc>();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  qr.Barcode? scanQrResult;
  qr.QRViewController? _cameraController;
  StreamSubscription<qr.Barcode>? _scanQrSubscription;

  @override
  void dispose() {
    _cameraController?.dispose();
    _scanQrSubscription?.cancel();
    _bloc.close();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _cameraController!.pauseCamera();
      return;
    }

    _cameraController!.resumeCamera();
  }

  void _onQRViewCreated(qr.QRViewController controller) {
    _cameraController = controller;
    _scanQrSubscription = _cameraController?.scannedDataStream.listen(
      _onDataScanned,
      onError: _onGetError,
    );
    _initCameraState();
  }

  void _onDataScanned(qr.Barcode scanData) {
    _cameraController?.pauseCamera();
    _bloc.onScanSuccess(scanData);
  }

  void _onGetError(dynamic error) {
    _bloc.onScanError();
  }

  Future<void> _initCameraState() async {
    final isFlashOn = await _cameraController?.getFlashStatus() ?? false;
    _bloc.initFlashState(isFlashOn);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => context.router.pop(),
        icon: const Icon(Icons.arrow_back_ios),
      ),
      title: Text(
        tr(LocaleKeys.ScanQRCode),
        style: AppTextStyles.bold(color: AppColors.white),
      ),
    );
  }

  Widget _buildBody() {
    return MultiBlocListener(
      listeners: [
        ScanningScreenStateSuccessListener(listener: _onSuccess),
        ScanningScreenStateFailedListener(listener: _onFailed),
      ],
      child: SafeArea(
        child: Column(
          children: [
            _buildCameraView(),
            _buildButtonSection(),
          ],
        ),
      ),
    );
  }

  void _onSuccess(BuildContext context, ScanningState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AppBaseDialog(
          title: context.tr(LocaleKeys.Success),
          // Null value won't trigger success listener
          content: _getDialogContent(state.barcodeEntity!),
          positiveButtonText: context.tr(LocaleKeys.OK),
          negativeButtonText: context.tr(LocaleKeys.Cancel),
          onPressPositiveButton: () {
            context.router.popUntilRoot();
          },
          onPressNegativeButton: () {
            context.router.pop();
            _cameraController?.resumeCamera();
          },
        );
      },
    );
  }

  String _getDialogContent(BarcodeEntity entity) {
    final question = context.tr(LocaleKeys.DoYouWantToSaveThis);
    switch (entity.runtimeType) {
      case BarcodeWifiEntity:
        final wifiEntity = (entity as BarcodeWifiEntity);
        final ssid = wifiEntity.ssid ?? context.tr(LocaleKeys.Unknown);
        final password = wifiEntity.password ?? context.tr(LocaleKeys.NoPassword);
        final value = '${context.tr(LocaleKeys.YourCodeIs)}:\n$ssid\n$password';
        return '$value\n\n$question';
      case BarcodeUrlEntity:
        final urlEntity = (entity as BarcodeUrlEntity);
        final title = urlEntity.title ?? context.tr(LocaleKeys.NotTitle);
        final url = urlEntity.url ?? context.tr(LocaleKeys.InvalidLink);
        final value = '${context.tr(LocaleKeys.YourCodeIs)}:\n$title\n$url';
        return '$value\n\n$question';
      default:
        return '';
    }
  }

  void _onFailed(BuildContext context, ScanningState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AppBaseDialog(
          title: context.tr(LocaleKeys.Failed),
          // Null value won't trigger success listener
          isErrorDialog: true,
          content: context.tr(LocaleKeys.CantGetBarcode),
          positiveButtonText: context.tr(LocaleKeys.OK),
          onPressPositiveButton: () {
            context.router.pop();
            _cameraController?.resumeCamera();
          },
        );
      },
    );
  }

  Widget _buildCameraView() {
    return Expanded(
      flex: 5,
      child: qr.QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        cameraFacing: qr.CameraFacing.back,
        overlay: qr.QrScannerOverlayShape(
          borderColor: AppColors.tealPrimary,
          borderWidth: AppSize.s10,
          borderRadius: AppBorderRadius.r10,
        ),
      ),
    );
  }

  Widget _buildButtonSection() {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFlashButton(),
            _buildToggleCameraButton(),
            _buildImportImageButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFlashButton() {
    return BlocSelector<ScanningBloc, ScanningState, bool>(
      selector: (state) {
        return state.isFlashOn;
      },
      builder: (context, isFlashOn) {
        return ImageButton(
          imagePath: isFlashOn ? AppImages.icFlashOn : AppImages.icFlashOff,
          backgroundColor: AppColors.bgDisable,
          size: AppSize.s40,
          onPressed: _onToggleFlash,
        );
      },
    );
  }

  Widget _buildToggleCameraButton() {
    return ImageButton(
      imagePath: AppImages.icSwitchCamera,
      size: AppSize.s50,
      hasShadow: true,
      onPressed: _onToggleCamera,
    );
  }

  Widget _buildImportImageButton() {
    return ImageButton(
      imagePath: AppImages.icImportImage,
      backgroundColor: AppColors.bgDisable,
      size: AppSize.s40,
      onPressed: _onPressImportImage,
    );
  }

  void _onToggleFlash() {
    _cameraController?.toggleFlash();
    _bloc.toggleFlash();
  }

  void _onToggleCamera() => _cameraController?.flipCamera();

  void _onPressImportImage() async {
    await _cameraController?.pauseCamera();
    _bloc.getBarcodeValues();
  }
}
