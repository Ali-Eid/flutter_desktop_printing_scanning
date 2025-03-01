import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'classes.dart';
import 'flutter_desktop_scanner_method_channel.dart';

abstract class FlutterDesktopScannerPlatform extends PlatformInterface {
  /// Constructs a FlutterDesktopScannerPlatform.
  FlutterDesktopScannerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterDesktopScannerPlatform _instance =
      MethodChannelFlutterDesktopScanner();

  /// The default instance of [FlutterDesktopScannerPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterDesktopScanner].
  static FlutterDesktopScannerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterDesktopScannerPlatform] when
  /// they register themselves.
  static set instance(FlutterDesktopScannerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError("platformVersion() has not been implemented.");
  }

  Future<bool> initGetDevices() {
    throw UnimplementedError("initGetDevices() has not been implemented.");
  }

  Stream<List<Scanner>> getDevicesStream() {
    throw UnimplementedError("getDevicesStream() has not been implemented.");
  }

  Future<bool> initScan(Scanner scanner) {
    throw UnimplementedError("initScan() has not been implemented.");
  }

  Stream<Uint8List?> rawBytesStream() {
    throw UnimplementedError("rawBytesStream() has not been implemented.");
  }

  Stream<img.Image?> imageReprStream() {
    throw UnimplementedError("rawPNMStream() has not been implemented.");
  }
}
