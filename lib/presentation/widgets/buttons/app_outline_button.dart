import 'package:camera_qr_project/resources/colors/app_colors.dart';
import 'package:camera_qr_project/resources/fonts/app_font.dart';
import 'package:camera_qr_project/resources/styles/app_text_style.dart';
import 'package:flutter/material.dart';

class AppOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool hasBorder;
  final double? borderWidth;
  final Color? colorText;
  final Color? borderColor;
  final Color? bgColor;
  final double? fontSizeText;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? paddingButton;
  final bool isLoading;

  const AppOutlinedButton({
    Key? key,
    this.onPressed,
    required this.label,
    this.hasBorder = true,
    this.colorText,
    this.borderWidth,
    this.borderColor,
    this.bgColor,
    this.fontSizeText,
    this.labelStyle,
    this.paddingButton,
    this.isLoading = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        side: !hasBorder || isLoading
            ? const BorderSide(color: Colors.transparent)
            : borderWidth != null
                ? BorderSide(
                    width: borderWidth!,
                    color: borderColor ?? AppColors.tealPrimary,
                  )
                : null,
        backgroundColor: isLoading ? AppColors.bgDisable : bgColor,
        padding: paddingButton,
      ),
      child: isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.white,
              ),
            )
          : Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: labelStyle ??
                  AppTextStyles.bold(
                    color: colorText != null ? colorText! : AppColors.tealPrimary,
                    fontSize: fontSizeText ?? AppFontSize.s16,
                  ),
            ),
    );
  }
}
