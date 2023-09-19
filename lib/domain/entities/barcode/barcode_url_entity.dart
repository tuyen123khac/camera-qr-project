import 'package:camera_qr_project/domain/entities/barcode/barcode_entity.dart';

class BarcodeUrlEntity extends BarcodeEntity {
  final String? title;
  final String? url;

  BarcodeUrlEntity({
    this.title,
    this.url,
  });
}
