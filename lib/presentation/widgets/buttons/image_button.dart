import 'package:camera_qr_project/resources/colors/app_colors.dart';
import 'package:camera_qr_project/resources/values/app_values.dart';
import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  final String imagePath;
  final double? padding;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? imageColor;
  final double? size;
  final bool hasShadow;
  final VoidCallback? onPressed;

  const ImageButton({
    Key? key,
    required this.imagePath,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.imageColor,
    this.size,
    this.hasShadow = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(padding ?? AppPadding.p16),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.tealTertiary,
          borderRadius: BorderRadius.circular(AppBorderRadius.r16),
          boxShadow: hasShadow
              ? [
                  BoxShadow(
                    color: AppColors.boxShadow,
                    offset: AppOffset.o04,
                    blurRadius: AppBlurRadius.b10,
                    spreadRadius: AppSpreadRadius.s0,
                  ),
                ]
              : null,
        ),
        child: Image.asset(
          imagePath,
          color: imageColor,
          height: size,
          width: size,
        ),
      ),
    );
  }
}
