import 'package:flutter/material.dart';

class GlobalState {
  Locale locale;
  
  GlobalState({
    required this.locale,
  });

  GlobalState copyWith({
    Locale? locale,
  }) {
    return GlobalState(
      locale: locale ?? this.locale,
    );
  }
}
