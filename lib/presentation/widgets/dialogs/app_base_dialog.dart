import 'package:flutter/material.dart';

import 'package:camera_qr_project/presentation/widgets/buttons/app_filled_button.dart';
import 'package:camera_qr_project/presentation/widgets/buttons/app_outline_button.dart';
import 'package:camera_qr_project/resources/colors/app_colors.dart';
import 'package:camera_qr_project/resources/fonts/app_font.dart';
import 'package:camera_qr_project/resources/images/app_images.dart';
import 'package:camera_qr_project/resources/styles/app_text_style.dart';
import 'package:camera_qr_project/resources/values/app_values.dart';

class AppBaseDialog extends StatelessWidget {
  final String title;
  final bool isErrorDialog;
  final String? content;
  final String? positiveButtonText;
  final String? negativeButtonText;
  final VoidCallback? onPressPositiveButton;
  final VoidCallback? onPressNegativeButton;

  const AppBaseDialog({
    Key? key,
    required this.title,
    this.isErrorDialog = false,
    this.content,
    this.positiveButtonText,
    this.negativeButtonText,
    this.onPressPositiveButton,
    this.onPressNegativeButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildImage(),
            _buildTitle(),
            _buildContentText(),
            _buildPositiveButton(),
            _buildNegativeButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Image.asset(
      isErrorDialog ? AppImages.icFailed : AppImages.icSuccess,
      height: AppSize.s60,
      width: AppSize.s60,
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: const EdgeInsets.only(top: AppMargin.m16),
      child: Text(
        title,
        style: AppTextStyles.bold(
          color: AppColors.greyPrimary,
          fontSize: AppFontSize.s16,
        ),
      ),
    );
  }

  Widget _buildContentText() {
    return Container(
      margin: const EdgeInsets.only(top: AppMargin.m16),
      child: Text(
        content ?? '',
        style: AppTextStyles.bold(
          color: AppColors.greySecondary,
          fontSize: AppFontSize.s14,
        ),
      ),
    );
  }

  Widget _buildPositiveButton() {
    return positiveButtonText != null
        ? Container(
            padding: const EdgeInsets.only(top: AppPadding.p16),
            width: double.infinity,
            child: AppFilledButton(
              label: positiveButtonText ?? '',
              color: isErrorDialog ? AppColors.errorPrimary : null,
              onPressed: onPressPositiveButton,
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildNegativeButton() {
    return negativeButtonText != null
        ? Container(
            padding: const EdgeInsets.only(top: AppPadding.p8),
            width: double.infinity,
            child: AppOutlinedButton(
              label: negativeButtonText ?? '',
              hasBorder: true,
              colorText: isErrorDialog ? AppColors.errorPrimary : AppColors.tealPrimary,
              onPressed: onPressNegativeButton,
            ),
          )
        : const SizedBox.shrink();
  }
}
