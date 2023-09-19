# camera_qr_project

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Helpful command:

### Generate file
When you need to generate some annotation file:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Generate new translated text

```bash
flutter pub run easy_localization:generate \
  -f keys \
  -S lib/presentation/languages/translations \
  -O lib/presentation/languages \
  -o translation_keys.g.dart
```
