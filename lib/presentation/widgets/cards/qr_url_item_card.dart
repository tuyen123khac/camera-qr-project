import 'package:camera_qr_project/domain/barcode/barcode_url_entity.dart';
import 'package:camera_qr_project/resources/colors/app_colors.dart';
import 'package:camera_qr_project/resources/fonts/app_font.dart';
import 'package:camera_qr_project/resources/images/app_images.dart';
import 'package:camera_qr_project/resources/languages/translation_keys.g.dart';
import 'package:camera_qr_project/resources/styles/app_text_style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class QrUrlItemCard extends StatelessWidget {
  final BarcodeUrlEntity barcodeUrl;

  const QrUrlItemCard({
    Key? key,
    required this.barcodeUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        AppImages.icWeb,
        height: 30,
        width: 30,
      ),
      title: Text(
        barcodeUrl.title ?? context.tr(LocaleKeys.NotTitle),
        style: AppTextStyles.bold(
          color: AppColors.greySecondary,
          fontSize: AppFontSize.s14,
        ),
      ),
      subtitle: Text(
        barcodeUrl.url ?? context.tr(LocaleKeys.InvalidLink),
        style: AppTextStyles.bold(
          color: AppColors.greySecondary,
          fontSize: AppFontSize.s14,
        ),
      ),
    );
  }
}
