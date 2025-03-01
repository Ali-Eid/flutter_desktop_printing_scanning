import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'classes.dart';
import 'flutter_desktop_scanner_platform_interface.dart';

export 'classes.dart';

class FlutterDesktopScanner {
  Future<String?> getPlatformVersion() {
    return FlutterDesktopScannerPlatform.instance.getPlatformVersion();
  }

  Future<bool> initGetDevices() {
    return FlutterDesktopScannerPlatform.instance.initGetDevices();
  }

  Stream<List<Scanner>> getDevicesStream() {
    return FlutterDesktopScannerPlatform.instance.getDevicesStream();
  }

  Future<bool> initScan(Scanner scanner) {
    return FlutterDesktopScannerPlatform.instance.initScan(scanner);
  }

  Stream<Uint8List?> rawBytesStream() {
    return FlutterDesktopScannerPlatform.instance.rawBytesStream();
  }

  Stream<img.Image?> imageReprStream() {
    return FlutterDesktopScannerPlatform.instance.imageReprStream();
  }
}
