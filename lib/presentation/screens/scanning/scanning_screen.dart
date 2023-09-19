import 'dart:async';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:auto_route/auto_route.dart';
import 'package:camera_qr_project/data/di.dart';
import 'package:camera_qr_project/domain/entities/barcode/barcode_entity.dart';
import 'package:camera_qr_project/domain/entities/barcode/barcode_url_entity.dart';
import 'package:camera_qr_project/domain/entities/barcode/barcode_wifi_entity.dart';
import 'package:camera_qr_project/presentation/screens/scanning/bloc/scanning_bloc.dart';
import 'package:camera_qr_project/presentation/screens/scanning/bloc/scanning_selector.dart';
import 'package:camera_qr_project/presentation/screens/scanning/bloc/scanning_state.dart';
import 'package:camera_qr_project/presentation/widgets/buttons/app_outline_button.dart';
import 'package:camera_qr_project/presentation/widgets/buttons/image_button.dart';
import 'package:camera_qr_project/presentation/widgets/dialogs/app_base_dialog.dart';
import 'package:camera_qr_project/resources/colors/app_colors.dart';
import 'package:camera_qr_project/resources/images/app_images.dart';
import 'package:camera_qr_project/presentation/languages/translation_keys.g.dart';
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

class _ScanningScreenState extends State<ScanningScreen> with WidgetsBindingObserver {
  final ScanningBloc _bloc = provider.get<ScanningBloc>();
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  qr.QRViewController? _cameraController;
  StreamSubscription<qr.Barcode>? _scanQrSubscription;

  @override
  void initState() {
    _bloc.handlePermission();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _scanQrSubscription?.cancel();
    _bloc.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _cameraController?.pauseCamera();
      return;
    }

    _cameraController?.resumeCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _handleResumeState();
        break;
      case AppLifecycleState.paused:
        _handlePausedState();
      default:
    }
  }

  void _handleResumeState() {
    _cameraController?.resumeCamera();
    _bloc.handlePermission();
  }

  void _handlePausedState() {
    _cameraController?.pauseCamera();
  }

  void _onQRViewCreated(qr.QRViewController controller) {
    _cameraController = controller;
    _scanQrSubscription = _cameraController?.scannedDataStream.listen(
      _onDataScanned,
      onError: _onGetError,
    );
    _initFlashState();
  }

  void _onDataScanned(qr.Barcode scanData) {
    _cameraController?.pauseCamera();
    _bloc.onScanSuccess(scanData);
  }

  void _onGetError(dynamic error) {
    _bloc.onScanError();
  }

  Future<void> _initFlashState() async {
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
        ScanningScreenStateSuccessListener(listener: _onScanSuccess),
        ScanningScreenStateFailedListener(listener: _onScanFailed),
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

  void _onScanSuccess(BuildContext context, ScanningState state) {
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

  void _onScanFailed(BuildContext context, ScanningState state) {
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
      child: ScanningScreenPermissionGrantedSelector(
        builder: (isGranted) {
          if (isGranted) return _buildQrView();

          return _buildPermissionView();
        },
      ),
    );
  }

  Widget _buildQrView() {
    return qr.QRView(
      key: _qrKey,
      onQRViewCreated: _onQRViewCreated,
      cameraFacing: qr.CameraFacing.back,
      overlay: qr.QrScannerOverlayShape(
        borderColor: AppColors.tealPrimary,
        borderWidth: AppSize.s10,
        borderRadius: AppBorderRadius.r10,
      ),
    );
  }

  Widget _buildPermissionView() {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.icPermission,
              height: AppSize.s60,
              width: AppSize.s60,
            ),
            const SizedBox(height: AppMargin.m16),
            Text(
              context.tr(LocaleKeys.NoCameraPermissionAllowed),
              style: AppTextStyles.bold(
                color: AppColors.greyTertiary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppMargin.m8),
            Text(
              context.tr(LocaleKeys.PleaseEnableCamera),
              style: AppTextStyles.regular(
                color: AppColors.greyTertiary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppMargin.m16),
            AppOutlinedButton(
              label: context.tr(LocaleKeys.OpenSettings),
              onPressed: () => AppSettings.openAppSettings(),
            )
          ],
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
    return ScanningScreenIsFlashOnSelector(
      builder: (isFlashOn) => ImageButton(
        imagePath: isFlashOn ? AppImages.icFlashOn : AppImages.icFlashOff,
        backgroundColor: AppColors.bgDisable,
        size: AppSize.s40,
        onPressed: _onToggleFlash,
      ),
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
