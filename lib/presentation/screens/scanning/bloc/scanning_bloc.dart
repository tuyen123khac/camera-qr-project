import 'package:camera_qr_project/presentation/screens/scanning/bloc/scanning_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanningBloc extends Cubit<ScanningState> {
  ScanningBloc() : super(ScanningState());

  void initFlashState(bool value) {
    emit(state.copyWith(isFlashOn: value));
  }

  void toggleFlash() {
    emit(state.copyWith(isFlashOn: !state.isFlashOn));
  }

  
}
