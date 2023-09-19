import 'package:auto_route/auto_route.dart';
import 'package:camera_qr_project/application/utils/string_extension.dart';
import 'package:camera_qr_project/domain/bloc/global/global_bloc.dart';
import 'package:camera_qr_project/domain/bloc/global/global_state.dart';
import 'package:camera_qr_project/presentation/languages/app_languages.dart';
import 'package:camera_qr_project/presentation/navigation/app_navigation.dart';
import 'package:camera_qr_project/presentation/widgets/buttons/image_button.dart';
import 'package:camera_qr_project/resources/colors/app_colors.dart';
import 'package:camera_qr_project/resources/images/app_images.dart';
import 'package:camera_qr_project/presentation/languages/translation_keys.g.dart';
import 'package:camera_qr_project/resources/styles/app_text_style.dart';
import 'package:camera_qr_project/resources/values/app_values.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        title: Text(
          context.tr(LocaleKeys.Dashboard),
          style: AppTextStyles.bold(color: AppColors.white),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<GlobalBloc, GlobalState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  showBottomSheet(
                    context: context,
                    builder: (ctx) {
                      return ListView.builder(
                        itemCount: AppLanguages.supportedLanguages.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => context
                                .read<GlobalBloc>()
                                .changeLocale(AppLanguages.supportedLanguages[index].locale),
                            child: ListTile(
                              title: Text(AppLanguages.supportedLanguages[index].name),
                              trailing: Text(AppLanguages.supportedLanguages[index].flag),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                icon: Text(AppLanguages.parseLanguage(state.locale.languageCode).flag),
              );
            },
          )
        ],
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
                onPressed: () => context.router.push(const TakePhotoRoute()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
