import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:camera_qr_project/data/di.dart';
import 'package:camera_qr_project/presentation/screens/scanning/bloc/scanning_bloc.dart';
import 'package:camera_qr_project/presentation/screens/scanning/bloc/scanning_state.dart';
import 'package:camera_qr_project/presentation/widgets/buttons/image_button.dart';
import 'package:camera_qr_project/resources/colors/app_colors.dart';
import 'package:camera_qr_project/resources/images/app_images.dart';
import 'package:camera_qr_project/resources/languages/translation_keys.g.dart';
import 'package:camera_qr_project/resources/styles/app_text_style.dart';
import 'package:camera_qr_project/resources/values/app_values.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
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
  qr.Barcode? result;
  qr.QRViewController? _controller;
  StreamSubscription<qr.Barcode>? _streamSubscription;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _controller?.dispose();
    _streamSubscription?.cancel();
    _bloc.close();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller!.pauseCamera();
      return;
    }

    _controller!.resumeCamera();
  }

  void _onQRViewCreated(qr.QRViewController controller) {
    _controller = controller;
    _streamSubscription = _controller?.scannedDataStream.listen((scanData) {});
    _initCameraState();
  }

  Future<void> _initCameraState() async {
    final isFlashOn = await _controller?.getFlashStatus() ?? false;
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
    return SafeArea(
      child: Column(
        children: [
          _buildCameraView(),
          _buildButtonSection(),
        ],
      ),
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
    _controller?.toggleFlash();
    _bloc.toggleFlash();
  }

  void _onToggleCamera() => _controller?.flipCamera();

  void _onPressImportImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    final imagePath = image?.path;

    if (imagePath == null) return;
    final InputImage inputImage = InputImage.fromFilePath(imagePath);
    final List<BarcodeFormat> formats = [BarcodeFormat.qrCode];
    final barcodeScanner = BarcodeScanner(formats: formats);

    final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);

    for (Barcode barcode in barcodes) {
      final BarcodeType type = barcode.type;
      final Rect boundingBox = barcode.boundingBox;
      final String? displayValue = barcode.displayValue;
      final String? rawValue = barcode.rawValue;

      // See API reference for complete list of supported types
      switch (type) {
        case BarcodeType.wifi:
          final barcodeWifi = barcode.value as BarcodeWifi;
          print(barcodeWifi);
          print(barcodeWifi.ssid);
          print(barcodeWifi.password);
          print(barcodeWifi.encryptionType);
          break;
        case BarcodeType.url:
          final barcodeUrl = barcode.value as BarcodeUrl;
          break;
        default:
      }
    }
  }
}
