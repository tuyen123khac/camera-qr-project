import 'package:auto_route/auto_route.dart';
import 'package:camera_qr_project/domain/bloc/global/global_bloc.dart';
import 'package:camera_qr_project/domain/bloc/global/global_state.dart';
import 'package:camera_qr_project/presentation/navigation/app_navigation.dart';
import 'package:camera_qr_project/resources/styles/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  final _appRouter = AppRouter();
  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GlobalBloc, GlobalState>(
          listenWhen: (previous, current) => previous.locale != current.locale,
          listener: (context, state) => context.setLocale(state.locale),
        ),
      ],
      child: BlocBuilder<GlobalBloc, GlobalState>(
        buildWhen: (previous, current) => previous.locale != current.locale,
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Camera app',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: state.locale,
            theme: AppTheme.getTheme(),
            routerConfig: _appRouter.config(
              navigatorObservers: () => [AutoRouteObserver()],
            ),
          );
        },
      ),
    );
  }
}
