// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_navigation.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashScreen(),
      );
    },
    DashboardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DashboardScreen(),
      );
    },
    ScanningRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ScanningScreen(),
      );
    },
    TakePhotoRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TakePhotoScreen(),
      );
    },
    ViewPhotoRoute.name: (routeData) {
      final args = routeData.argsAs<ViewPhotoRouteArgs>(
          orElse: () => const ViewPhotoRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ViewPhotoScreen(
          key: args.key,
          imageFile: args.imageFile,
        ),
      );
    },
  };
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DashboardScreen]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
      : super(
          DashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ScanningScreen]
class ScanningRoute extends PageRouteInfo<void> {
  const ScanningRoute({List<PageRouteInfo>? children})
      : super(
          ScanningRoute.name,
          initialChildren: children,
        );

  static const String name = 'ScanningRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TakePhotoScreen]
class TakePhotoRoute extends PageRouteInfo<void> {
  const TakePhotoRoute({List<PageRouteInfo>? children})
      : super(
          TakePhotoRoute.name,
          initialChildren: children,
        );

  static const String name = 'TakePhotoRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ViewPhotoScreen]
class ViewPhotoRoute extends PageRouteInfo<ViewPhotoRouteArgs> {
  ViewPhotoRoute({
    Key? key,
    XFile? imageFile,
    List<PageRouteInfo>? children,
  }) : super(
          ViewPhotoRoute.name,
          args: ViewPhotoRouteArgs(
            key: key,
            imageFile: imageFile,
          ),
          initialChildren: children,
        );

  static const String name = 'ViewPhotoRoute';

  static const PageInfo<ViewPhotoRouteArgs> page =
      PageInfo<ViewPhotoRouteArgs>(name);
}

class ViewPhotoRouteArgs {
  const ViewPhotoRouteArgs({
    this.key,
    this.imageFile,
  });

  final Key? key;

  final XFile? imageFile;

  @override
  String toString() {
    return 'ViewPhotoRouteArgs{key: $key, imageFile: $imageFile}';
  }
}
