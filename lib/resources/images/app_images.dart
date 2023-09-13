class AppImages {
  static String appLogo = ImagePath.getPath('app_logo.png');
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
      return 'assets/images/json/$name';
    }
    if (name.contains('.gif')) {
      return 'assets/images/gif/$name';
    }
    return 'assets/images/svg/$name';
  }
}
