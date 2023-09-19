import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:camera_qr_project/application/enums/camera_enum.dart';
import 'package:camera_qr_project/data/di.dart';
import 'package:camera_qr_project/presentation/navigation/app_navigation.dart';
import 'package:camera_qr_project/presentation/screens/take_photo/bloc/take_photo_bloc.dart';
import 'package:camera_qr_project/presentation/screens/take_photo/bloc/take_photo_selector.dart';
import 'package:camera_qr_project/presentation/widgets/buttons/app_outline_button.dart';
import 'package:camera_qr_project/presentation/widgets/buttons/image_button.dart';
import 'package:camera_qr_project/resources/colors/app_colors.dart';
import 'package:camera_qr_project/resources/images/app_images.dart';
import 'package:camera_qr_project/presentation/languages/translation_keys.g.dart';
import 'package:camera_qr_project/resources/styles/app_text_style.dart';
import 'package:camera_qr_project/resources/values/app_values.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class TakePhotoScreen extends StatefulWidget {
  const TakePhotoScreen({super.key});

  @override
  State<TakePhotoScreen> createState() => _TakePhotoScreenState();
}

class _TakePhotoScreenState extends State<TakePhotoScreen> with AutoRouteAwareStateMixin {
  final TakePhotoBloc _bloc = provider.get<TakePhotoBloc>();
  late List<CameraDescription> _cameras;
  late CameraController _controller;
  var _isBackCameraUsed = true;

  @override
  void initState() {
    _setupCameras();
    super.initState();
  }

  void _setupCameras() async {
    _cameras = await availableCameras();
    _initCurrentCamera();
  }

  @override
  void didPopNext() {
    _controller.resumePreview();
  }

  @override
  void dispose() {
    _controller.dispose();
    _bloc.close();
    super.dispose();
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
        context.tr(LocaleKeys.TakePhoto),
        style: AppTextStyles.bold(color: AppColors.white),
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: _buildCameraSection(),
    );
  }

  Widget _buildCameraSection() {
    return InitCameraStatusSelector(
      builder: (screenState) {
        switch (screenState) {
          case CameraScreenState.initial:
            return _buildLoadingView();
          case CameraScreenState.initFailed:
            return _buildInitFailedView();
          case CameraScreenState.initSuccess:
            return _buildCameraView();
          default:
            return _buildCameraView();
        }
      },
    );
  }

  Widget _buildLoadingView() {
    return Center(child: Container(color: AppColors.white));
  }

  Widget _buildInitFailedView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppImages.icFailed,
            height: AppSize.s60,
            width: AppSize.s60,
          ),
          const SizedBox(height: AppMargin.m16),
          Text(
            context.tr(LocaleKeys.SomethingWentWrong),
            style: AppTextStyles.bold(
              color: AppColors.greyTertiary,
            ),
          ),
          const SizedBox(height: AppMargin.m16),
          AppOutlinedButton(
            label: context.tr(LocaleKeys.TryAgain),
            onPressed: _onTryAgainPressed,
          )
        ],
      ),
    );
  }

  void _onTryAgainPressed() {
    _initCurrentCamera();
  }

  void _initCurrentCamera() async {
    try {
      _bloc.onInitCamera();

      _controller = CameraController(
        _isBackCameraUsed ? _cameras[0] : _cameras[1],
        ResolutionPreset.max,
      );

      await _controller.initialize();
      _controller.setFocusMode(FocusMode.auto);

      _bloc.onInitCameraSuccess();
    } catch (e) {
      _bloc.onInitCameraFailed();
    }
  }

  Widget _buildCameraView() {
    return CameraPreview(
      _controller,
      child: Column(
        children: [
          _buildHeaderButton(),
          const Spacer(),
          _buildCameraButton(),
        ],
      ),
    );
  }

  Widget _buildCameraButton() {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p16),
      child: ImageButton(
        imagePath: AppImages.icLens,
        backgroundColor: AppColors.white,
        size: AppSize.s30,
        onPressed: _onCameraButtonPressed,
      ),
    );
  }

  void _onCameraButtonPressed() async {
    await _controller.setFocusMode(FocusMode.locked);
    await _controller.setExposureMode(ExposureMode.locked);
    final xFile = await _controller.takePicture();
    await _controller.setFocusMode(FocusMode.auto);
    await _controller.setExposureMode(ExposureMode.auto);

    if (context.mounted) {
      _controller.pausePreview();
      context.router.push(ViewPhotoRoute(imageFile: xFile));
    }
  }

  Widget _buildHeaderButton() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFlashButton(),
            _buildToggleCameraButton(),
          ],
        ),
        _buildFlashOptions(),
      ],
    );
  }

  Widget _buildFlashOptions() {
    return DisplayFlashOptionsSelector(
      builder: (isShowing) {
        return isShowing
            ? Row(
                children: [
                  ImageButton(
                    imagePath: AppImages.icFlashOff,
                    size: AppSize.s30,
                    imageColor: AppColors.white,
                    backgroundColor: Colors.transparent,
                    onPressed: () => _setFlashMode(FlashMode.off),
                  ),
                  ImageButton(
                    imagePath: AppImages.icFlashAuto,
                    size: AppSize.s30,
                    imageColor: AppColors.white,
                    backgroundColor: Colors.transparent,
                    onPressed: () => _setFlashMode(FlashMode.auto),
                  ),
                  ImageButton(
                    imagePath: AppImages.icFlashOn,
                    size: AppSize.s30,
                    imageColor: AppColors.white,
                    backgroundColor: Colors.transparent,
                    onPressed: () => _setFlashMode(FlashMode.always),
                  ),
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }

  Widget _buildFlashButton() {
    return DisplayFlashModeSelector(
      builder: (flashMode) {
        return ImageButton(
          imagePath: _getFlashIconPath(flashMode),
          size: AppSize.s30,
          imageColor: AppColors.white,
          backgroundColor: Colors.transparent,
          onPressed: () => _bloc.toggleFlashOptions(),
        );
      },
    );
  }

  String _getFlashIconPath(FlashMode flashMode) {
    switch (flashMode) {
      case FlashMode.off:
        return AppImages.icFlashOff;
      case FlashMode.always:
        return AppImages.icFlashOn;
      case FlashMode.auto:
        return AppImages.icFlashAuto;
      default:
        return AppImages.icFlashOff;
    }
  }

  void _setFlashMode(FlashMode flashMode) {
    _controller.setFlashMode(flashMode);
    _bloc.setFlashMode(flashMode);
  }

  Widget _buildToggleCameraButton() {
    return ImageButton(
      imagePath: AppImages.icSwitchCamera,
      size: AppSize.s30,
      imageColor: AppColors.white,
      backgroundColor: Colors.transparent,
      onPressed: _onToggleCamera,
    );
  }

  void _onToggleCamera() async {
    _isBackCameraUsed = !_isBackCameraUsed;
    if (_cameras.length < 2) return;

    final previousController = _controller;
    await previousController.dispose();

    _initCurrentCamera();
  }
}
