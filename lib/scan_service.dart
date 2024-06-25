import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ScannerType {
  static const int TWAINSCANNER = 0x10;
  static const int WIASCANNER = 0x20;
  static const int TWAINX64SCANNER = 0x40;
  static const int ICASCANNER = 0x80;
  static const int SANESCANNER = 0x100;
  static const int ESCLSCANNER = 0x200;
  static const int WIFIDIRECTSCANNER = 0x400;
  static const int WIATWAINSCANNER = 0x800;
}

class DynamsoftService {
  Future<List<dynamic>> getDevices(String host, [int? scannerType]) async {
    List<dynamic> devices = [];
    String url = '$host/DWTAPI/Scanners';
    if (scannerType != null) {
      url += '?type=$scannerType';
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        devices = json.decode(response.body);
        return devices;
      }
    } catch (error) {}
    return [];
  }

  Future<String> scanDocument(
      String host, Map<String, dynamic> parameters) async {
    final url = '$host/DWTAPI/ScanJobs';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(parameters),
        headers: {'Content-Type': 'application/text'},
      );
      final jobId = response.body;

      if (response.statusCode == 201) {
        return jobId;
      }
    } catch (error) {}
    return '';
  }

  Future<void> deleteJob(String host, String jobId) async {
    if (jobId.isEmpty) return;
    final url = '$host/DWTAPI/ScanJobs/$jobId';

    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {}
    } catch (error) {}
  }

  Future<List<String>> getImageFiles(
      String host, String jobId, String directory) async {
    final List<String> images = [];
    final url = '$host/DWTAPI/ScanJobs/$jobId/NextDocument';
    while (true) {
      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final imagePath = join(directory, 'image_$timestamp.jpg');
          final file = File(imagePath);
          await file.writeAsBytes(response.bodyBytes);
          images.add(imagePath);
        } else if (response.statusCode == 410) {
          break;
        }
      } catch (error) {
        break;
      }
    }

    return images;
  }

  Future<List<Uint8List>> getImageStreams(String host, String jobId) async {
    final List<Uint8List> streams = [];
    final url = '$host/DWTAPI/ScanJobs/$jobId/NextDocument';

    while (true) {
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          streams.add(response.bodyBytes);
        } else if (response.statusCode == 410) {
          break;
        }
      } catch (error) {
        break;
      }
    }

    return streams;
  }
}
