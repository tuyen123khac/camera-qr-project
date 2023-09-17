import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:camera_qr_project/domain/barcode/barcode_wifi_entity.dart';
import 'package:camera_qr_project/resources/colors/app_colors.dart';
import 'package:camera_qr_project/resources/fonts/app_font.dart';
import 'package:camera_qr_project/resources/images/app_images.dart';
import 'package:camera_qr_project/resources/languages/translation_keys.g.dart';
import 'package:camera_qr_project/resources/styles/app_text_style.dart';

class QrWifiItemCard extends StatelessWidget {
  final BarcodeWifiEntity barcodeWifi;

  const QrWifiItemCard({
    Key? key,
    required this.barcodeWifi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        AppImages.icScanQr,
        height: 30,
        width: 30,
      ),
      title: Text(
        barcodeWifi.ssid ?? context.tr(LocaleKeys.Unknown),
        style: AppTextStyles.bold(
          color: AppColors.greySecondary,
          fontSize: AppFontSize.s14,
        ),
      ),
      subtitle: Text(
        barcodeWifi.password ?? context.tr(LocaleKeys.NoPassword),
        style: AppTextStyles.bold(
          color: AppColors.greySecondary,
          fontSize: AppFontSize.s14,
        ),
      ),
    );
  }
}
