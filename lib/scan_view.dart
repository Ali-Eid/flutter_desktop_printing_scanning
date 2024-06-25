import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:process_run/process_run.dart';
// import 'package:process_run/process_run.dart';

import 'scan_service.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  void _openScannerProgram() async {
    var shell = Shell();

    try {
      // This command attempts to open the default Windows Scan app
      await shell.run("C:\\WINDOWS\\system32\\WFS.exe");
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open Scanner Program'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _openScannerProgram,
          child: const Text('Open Scanner'),
        ),
      ),
    );
  }
}
