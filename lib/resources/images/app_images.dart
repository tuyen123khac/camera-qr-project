class AppImages {
  static String appLogo = ImagePath.getPath('app_logo.png');
  static String appLogoTransparent = ImagePath.getPath('app_logo_transparent.png');
  static String icRecordVideo = ImagePath.getPath('ic_record_video.png');
  static String icTakePhoto = ImagePath.getPath('ic_take_photo.png');
  static String icScanQr = ImagePath.getPath('ic_scan_qr.png');
  static String icSwitchCamera = ImagePath.getPath('ic_switch_camera.png');
  static String icFlashOn = ImagePath.getPath('ic_flash_on.png');
  static String icFlashOff = ImagePath.getPath('ic_flash_off.png');
  static String icImportImage = ImagePath.getPath('ic_import_image.png');
  static String icWeb = ImagePath.getPath('ic_web.png');
  static String icSuccess = ImagePath.getPath('ic_success.png');
  static String icFailed = ImagePath.getPath('ic_failed.png');
  static String lottieCameraLoading = ImagePath.getPath('lottie_camera_loading.json');
  static String icLens = ImagePath.getPath('ic_lens.png');
  static String icFlashAuto = ImagePath.getPath('ic_flash_auto.png');
  static String icPermission = ImagePath.getPath('ic_permission.png');
  static String scanQr = ImagePath.getPath('scan_qr.png');
  static String selfie = ImagePath.getPath('selfie.png');

  static String lottieLoading = ImagePath.getPath('lottie_loading.json');
  static String lottieScanQr = ImagePath.getPath('lottie_scan_qr.json');
  static String lottieTakePhoto = ImagePath.getPath('lottie_take_photo.json');
}

class ImagePath {
  static String getPath(String name) {
    if (name.contains('.svg')) {
      return 'assets/images/svg/$name';
    }
    if (name.contains('.png')) {
      return 'assets/images/png/$name';
    }
    if (name.contains('.jpg')) {
      return 'assets/images/jpg/$name';
    }
    if (name.contains('.json')) {
      return 'assets/lotties/$name';
    }
    if (name.contains('.gif')) {
      return 'assets/images/gif/$name';
    }
    return 'assets/images/svg/$name';
  }
}
