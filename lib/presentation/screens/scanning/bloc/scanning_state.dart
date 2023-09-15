enum ScreenState {
  initial,
  loading,
  success,
  failed,
}

class ScanningState {
  ScreenState screenState;
  String? value;
  bool isFlashOn;

  ScanningState({
    this.screenState = ScreenState.initial,
    this.value,
    this.isFlashOn = false
  });

  ScanningState copyWith({
    ScreenState? screenState,
    String? value,
    bool? isFlashOn,
  }) {
    return ScanningState(
      screenState: screenState ?? this.screenState,
      value: value ?? this.value,
      isFlashOn: isFlashOn ?? this.isFlashOn,
    );
  }
}
