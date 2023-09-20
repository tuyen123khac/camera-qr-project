import 'package:app_settings/app_settings.dart';
import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:camera_qr_project/application/enums/camera_enum.dart';
import 'package:camera_qr_project/data/di.dart';
import 'package:camera_qr_project/presentation/languages/translation_keys.g.dart';
import 'package:camera_qr_project/presentation/navigation/app_navigation.dart';
import 'package:camera_qr_project/presentation/screens/take_photo/bloc/take_photo_bloc.dart';
import 'package:camera_qr_project/presentation/screens/take_photo/bloc/take_photo_selector.dart';
import 'package:camera_qr_project/presentation/widgets/buttons/app_outline_button.dart';
import 'package:camera_qr_project/presentation/widgets/buttons/image_button.dart';
import 'package:camera_qr_project/resources/colors/app_colors.dart';
import 'package:camera_qr_project/resources/images/app_images.dart';
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

class _TakePhotoScreenState extends State<TakePhotoScreen>
    with AutoRouteAwareStateMixin, WidgetsBindingObserver {
  final TakePhotoBloc _bloc = provider.get<TakePhotoBloc>();
  late List<CameraDescription> _cameras;
  late CameraController _cameraController;
  var _isBackCameraUsed = true;

  @override
  void initState() {
    _setupCameras();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didPopNext() {
    _cameraController.resumePreview();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _bloc.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _setupCameras() async {
    _cameras = await availableCameras();
    _initCurrentCamera();
  }

  void _initCurrentCamera() async {
    try {
      _bloc.onInitCamera();

      _cameraController = CameraController(
        _isBackCameraUsed ? _cameras[0] : _cameras[1],
        ResolutionPreset.max,
      );

      await _cameraController.initialize();
      _cameraController.setFocusMode(FocusMode.auto);

      _bloc.onInitCameraSuccess();
    } catch (e) {
      if (e is CameraException &&
          (e.code == 'CameraAccessDenied' || e.code == 'AudioAccessDenied')) {
        _bloc.onInitCameraRequirePermission();
        return;
      }

      _bloc.onInitCameraFailed();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _handleResumeState();
        break;
      default:
    }
  }

  void _handleResumeState() {
    // This method is always triggered when no camera/microphone permission enabled
    // So cannot use this approach to auto re-init camera.
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
          case CameraScreenState.requirePermissions:
            return _buildRequestPermissionView();
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

  Widget _buildRequestPermissionView() {
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
            SizedBox(
              width: double.infinity,
              child: AppOutlinedButton(
                label: context.tr(LocaleKeys.OpenSettings),
                onPressed: () => AppSettings.openAppSettings(),
              ),
            ),
            const SizedBox(height: AppMargin.m16),
            Text(
              context.tr(LocaleKeys.IfYouHasEnabledThen),
              style: AppTextStyles.regular(
                color: AppColors.greyTertiary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppMargin.m16),
            SizedBox(
              width: double.infinity,
              child: AppOutlinedButton(
                label: context.tr(LocaleKeys.TryAgain),
                onPressed: _onTryAgainPressed,
              ),
            )
          ],
        ),
      ),
    );
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

  Widget _buildCameraView() {
    return CameraPreview(
      _cameraController,
      child: Column(
        children: [
          _buildHeaderButton(),
          const Spacer(),
          _buildCameraButton(),
        ],
      ),
    );
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
    _cameraController.setFlashMode(flashMode);
    _bloc.setFlashMode(flashMode);
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
    await _cameraController.setFocusMode(FocusMode.locked);
    await _cameraController.setExposureMode(ExposureMode.locked);
    final xFile = await _cameraController.takePicture();
    await _cameraController.setFocusMode(FocusMode.auto);
    await _cameraController.setExposureMode(ExposureMode.auto);

    if (context.mounted) {
      _cameraController.pausePreview();
      context.router.push(ViewPhotoRoute(imageFile: xFile));
    }
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

    final previousController = _cameraController;
    await previousController.dispose();

    _initCurrentCamera();
  }
}
