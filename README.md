# camera_qr_project

This project mainly works on exploring camera package.
Main features:
- Scan QR code
- Import QR image
- Take photo

![Alt text](/lib/dashboard.png?raw=true "Dashboard")
![Alt text](/lib/scan_qr.png?raw=true "Scan QR screen")

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
