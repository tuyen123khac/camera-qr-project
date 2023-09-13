import 'package:auto_route/auto_route.dart';
import 'package:camera_qr_project/presentation/navigation/app_navigation.dart';
import 'package:camera_qr_project/resources/styles/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  final _appRouter = AppRouter();
  App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(),
      routerConfig: _appRouter.config(
        navigatorObservers: () => [AutoRouteObserver()],
      ),
    );
  }
}
