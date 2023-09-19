import 'package:camera_qr_project/domain/entities/barcode/barcode_entity.dart';

class BarcodeWifiEntity extends BarcodeEntity {
  final String? ssid;
  final String? password;

  BarcodeWifiEntity({
    this.ssid,
    this.password,
  });
}
