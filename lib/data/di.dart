import 'package:camera_qr_project/presentation/screens/scanning/bloc/scanning_bloc.dart';
import 'package:get_it/get_it.dart';

final provider = GetIt.instance;

void injectDependencies() {
  // await _registerUseCases();
  _registerStates();
}

void _registerStates() {
  provider.registerFactory<ScanningBloc>(() => ScanningBloc());
}
