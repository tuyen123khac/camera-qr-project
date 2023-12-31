import 'package:auto_route/auto_route.dart';
import 'package:camera_qr_project/presentation/navigation/app_navigation.dart';
import 'package:camera_qr_project/resources/colors/app_colors.dart';
import 'package:camera_qr_project/resources/images/app_images.dart';
import 'package:camera_qr_project/resources/values/app_values.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _routeToDashboard();
    super.initState();
  }

  void _routeToDashboard() async {
    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) context.router.replace(const DashboardRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.tealPrimary,
        child: Center(
          child: Image.asset(
            AppImages.appLogoTransparent,
            color: AppColors.white,
            height: AppSize.s80,
            width: AppSize.s80,
          ),
        ),
      ),
    );
  }
}
