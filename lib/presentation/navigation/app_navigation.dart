import 'package:auto_route/auto_route.dart';
import 'package:camera_qr_project/presentation/screens/dash_board/dash_board_screen.dart';
import 'package:camera_qr_project/presentation/screens/scanning/scanning_screen.dart';
import 'package:camera_qr_project/presentation/screens/splash/splash_screen.dart';

part 'app_navigation.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  final List<AutoRoute> routes = [
    AutoRoute(path: '/', page: SplashRoute.page),
    AutoRoute(path: '/dashboard', page: DashboardRoute.page),
    AutoRoute(path: '/scanning', page: ScanningRoute.page),
  ];

  @override
  RouteType get defaultRouteType => const RouteType.cupertino();
}
