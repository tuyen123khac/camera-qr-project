import 'package:auto_route/auto_route.dart';
import 'package:camera_qr_project/presentation/navigation/app_navigation.dart';
import 'package:camera_qr_project/presentation/widgets/buttons/app_filled_button.dart';
import 'package:camera_qr_project/presentation/widgets/buttons/image_button.dart';
import 'package:camera_qr_project/resources/colors/app_colors.dart';
import 'package:camera_qr_project/resources/images/app_images.dart';
import 'package:camera_qr_project/resources/values/app_values.dart';
import 'package:flutter/material.dart';

@RoutePage()
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: Container(
        color: AppColors.bgDisable,
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          children: [
            Expanded(flex: 1, child: Text('a')),
            Expanded(flex: 1, child: Text('a')),
            _buildButtonSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonSection() {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.r16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ImageButton(
                imagePath: AppImages.icRecordVideo,
                size: AppSize.s50,
                hasShadow: true,
              ),
              ImageButton(
                imagePath: AppImages.icScanQr,
                size: AppSize.s50,
                hasShadow: true,
                onPressed: () => context.router.push(const ScanningRoute()),
              ),
              ImageButton(
                imagePath: AppImages.icTakePhoto,
                size: AppSize.s50,
                hasShadow: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
