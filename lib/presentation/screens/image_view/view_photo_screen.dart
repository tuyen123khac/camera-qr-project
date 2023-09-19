import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:camera_qr_project/presentation/widgets/buttons/app_filled_button.dart';
import 'package:camera_qr_project/resources/colors/app_colors.dart';
import 'package:camera_qr_project/resources/images/app_images.dart';
import 'package:camera_qr_project/presentation/languages/translation_keys.g.dart';
import 'package:camera_qr_project/resources/styles/app_text_style.dart';
import 'package:camera_qr_project/resources/values/app_values.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ViewPhotoScreen extends StatefulWidget {
  final XFile? imageFile;
  const ViewPhotoScreen({
    Key? key,
    this.imageFile,
  }) : super(key: key);

  @override
  State<ViewPhotoScreen> createState() => _ViewPhotoScreenState();
}

class _ViewPhotoScreenState extends State<ViewPhotoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: widget.imageFile != null ? _buildImageView() : _buildErrorView(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => context.router.pop(),
        icon: const Icon(Icons.arrow_back_ios),
      ),
      title: Text(
        context.tr(LocaleKeys.YourPhoto),
        style: AppTextStyles.bold(color: AppColors.white),
      ),
    );
  }

  Widget _buildImageView() {
    return ListView(
      children: [
        Image.file(
          File(widget.imageFile?.path ?? ''),
          fit: BoxFit.cover,
        ),
        const SizedBox(height: AppSize.s16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
          child: AppFilledButton(
            label: context.tr(LocaleKeys.Save),
            onPressed: () {
              // TODO save image path.
            },
          ),
        )
      ],
    );
  }

  Widget _buildErrorView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppImages.icFailed,
            height: AppSize.s50,
            width: AppSize.s50,
          ),
          const SizedBox(height: 16),
          Text(
            context.tr(LocaleKeys.UnableToLoadYourImage),
            style: AppTextStyles.medium(color: AppColors.greySecondary),
          ),
        ],
      ),
    );
  }
}
