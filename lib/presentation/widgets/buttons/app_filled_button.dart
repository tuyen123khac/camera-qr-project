import 'package:camera_qr_project/resources/colors/app_colors.dart';
import 'package:camera_qr_project/resources/values/app_values.dart';
import 'package:flutter/material.dart';

class AppFilledButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final Color? color;
  final Color? textColor;
  final Color? textColorDiable;
  final VoidCallback? onPressed;
  final bool isEnable;
  final bool hasShadow;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? paddingButton;

  const AppFilledButton({
    super.key,
    required this.label,
    this.isLoading = false,
    this.color,
    this.textColor,
    this.textColorDiable,
    this.onPressed,
    this.isEnable = true,
    this.hasShadow = true,
    this.labelStyle,
    this.paddingButton,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnable ? onPressed : null,
      style: ElevatedButton.styleFrom(
        onPrimary: !isEnable
            ? AppColors.greyTertiary
            : textColor != null
                ? textColor!
                : AppColors.white,
        primary: !isEnable
            ? AppColors.bgDisable
            : color != null
                ? color!
                : null,
        shadowColor: hasShadow ? AppColors.bgInput : Colors.transparent,
        textStyle: labelStyle,
        padding: paddingButton,
      ),
      child: isLoading
          ? SizedBox(
              width: AppSize.s20,
              height: AppSize.s20,
              child: CircularProgressIndicator(
                strokeWidth: AppSize.s2,
                color: AppColors.white,
              ),
            )
          : Text(
              label,
              style: TextStyle(color: isEnable ? null : textColorDiable ?? AppColors.white),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
    );
  }
}
