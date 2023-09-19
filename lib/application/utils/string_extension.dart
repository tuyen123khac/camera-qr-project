extension CountryCode on String {
  String get flagEmoji => toUpperCase() //
      .split('')
      .map((c) => c.codeUnitAt(0) + 127397)
      .map(String.fromCharCode)
      .join();
}
