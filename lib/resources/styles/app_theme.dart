import 'package:camera_qr_project/resources/colors/app_colors.dart';
import 'package:camera_qr_project/resources/fonts/app_font.dart';
import 'package:camera_qr_project/resources/styles/app_text_style.dart';
import 'package:camera_qr_project/resources/values/app_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static ThemeData getTheme() {
    return ThemeData(
        backgroundColor: Colors.transparent,
        // main colors
        colorScheme: ColorScheme.fromSwatch(
          errorColor: AppColors.errorPrimary,
          primaryColorDark: AppColors.tealPrimary,
          accentColor: AppColors.tealPrimary,
          backgroundColor: AppColors.white,
          cardColor: AppColors.white,
        ),
        primaryColorLight: AppColors.tealPrimary,
        canvasColor: AppColors.white,
        disabledColor: AppColors.bgDisable,
        // ripple color
        splashColor: AppColors.tealTertiary,
        //App bar
        appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: AppColors.tealPrimary,
                statusBarBrightness: Brightness.dark, //For iOS
                statusBarIconBrightness: Brightness.light //For android
                ),
            centerTitle: true,
            color: AppColors.tealPrimary,
            elevation: AppElevation.ev4,
            titleTextStyle:
                AppTextStyles.bold(color: AppColors.white, fontSize: AppFontSize.s26)),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: AppColors.tealPrimary,
            textStyle: AppTextStyles.bold(color: AppColors.tealPrimary, fontSize: AppFontSize.s16),
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }),

        // Elevated Button
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                elevation: AppElevation.ev2,
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
                fixedSize: const Size(AppButtonSize.width, AppButtonSize.height),
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.r8)),
                primary: AppColors.tealPrimary,
                onSurface: AppColors.tealSecondary,
                textStyle: AppTextStyles.bold(color: AppColors.white, fontSize: AppFontSize.s16))),
        //Outline Button
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.white,
            primary: AppColors.tealPrimary,
            fixedSize: const Size.fromHeight(AppSize.s44),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.r8),
                side: BorderSide(color: AppColors.tealPrimary, width: AppBorderWidth.w2)),
            side: BorderSide(
              color: AppColors.tealPrimary,
              width: AppBorderWidth.w2,
            ),
            textStyle: AppTextStyles.bold(color: AppColors.tealPrimary),
          ),
        ),
        // Text theme
        textTheme: TextTheme(
          headline1: AppTextStyles.bold(color: AppColors.greyPrimary, fontSize: AppFontSize.s30),
          headline2: AppTextStyles.bold(color: AppColors.greyPrimary, fontSize: AppFontSize.s26),
          headline3: AppTextStyles.medium(color: AppColors.greyPrimary, fontSize: AppFontSize.s24),
          headline4: AppTextStyles.bold(color: AppColors.greyPrimary, fontSize: AppFontSize.s22),
          subtitle1: AppTextStyles.regular(color: AppColors.greyPrimary, fontSize: AppFontSize.s16),
          subtitle2: AppTextStyles.regular(color: AppColors.greyPrimary, fontSize: AppFontSize.s14),
          bodyText1: AppTextStyles.regular(color: AppColors.greyPrimary, fontSize: AppFontSize.s18),
          bodyText2: AppTextStyles.regular(color: AppColors.greyPrimary, fontSize: AppFontSize.s16),
        ),
        // input decoration theme (text form field)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.bgInput,
          contentPadding: const EdgeInsets.all(AppPadding.p12),
          hintStyle: AppTextStyles.regular(color: AppColors.greyTertiary, fontSize: AppFontSize.s16)
              .copyWith(letterSpacing: 0),
          labelStyle: AppTextStyles.medium(color: AppColors.greyPrimary, fontSize: AppFontSize.s14),
          errorStyle: AppTextStyles.regular(color: Colors.transparent, fontSize: AppFontSize.s14),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.bgLight, width: AppBorderWidth.w1),
              borderRadius: const BorderRadius.all(Radius.circular(AppBorderRadius.r10))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.greyPrimary, width: AppBorderWidth.w1),
              borderRadius: const BorderRadius.all(Radius.circular(AppBorderRadius.r10))),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.error, width: AppBorderWidth.w1),
              borderRadius: const BorderRadius.all(Radius.circular(AppBorderRadius.r10))),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.greyPrimary, width: AppBorderWidth.w1),
              borderRadius: const BorderRadius.all(Radius.circular(AppBorderRadius.r10))),
        ));
  }
}
