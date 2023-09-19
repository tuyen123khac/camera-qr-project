import 'package:camera_qr_project/data/di.dart';
import 'package:camera_qr_project/domain/bloc/global/global_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalBlocProviders extends StatelessWidget {
  final Widget child;

  const GlobalBlocProviders({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GlobalBloc>.value(
          value: provider.get<GlobalBloc>(),
        ),
      ],
      child: child,
    );
  }
}
