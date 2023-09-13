import 'package:auto_route/auto_route.dart';
import 'package:camera_qr_project/presentation/navigation/app_navigation.dart';
import 'package:camera_qr_project/presentation/widgets/buttons/app_filled_button.dart';
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
        child: Column(
          children: [
            AppFilledButton(
              onPressed: () => context.router.push(const ScanningRoute()),
              label: 'Scan now',
            ),
          ],
        ),
      ),
    );
  }
}
