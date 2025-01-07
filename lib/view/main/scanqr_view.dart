import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  Uint8List? createdCodeBytes;

  Code? result;
  Codes? multiResult;

  bool isMultiScan = false;

  bool showDebugInfo = true;
  int successScans = 0;
  int failedScans = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quét mã")),
      body: Stack(
        children: [
          ReaderWidget(
            onScan: _onScanSuccess,
            onScanFailure: _onScanFailure,
            onMultiScan: _onMultiScanSuccess,
            onMultiScanFailure: _onMultiScanFailure,
            onMultiScanModeChanged: _onMultiScanModeChanged,
            onControllerCreated: _onControllerCreated,
            isMultiScan: isMultiScan,
            scanDelay: Duration(milliseconds: isMultiScan ? 50 : 500),
            resolution: ResolutionPreset.high,
            lensDirection: CameraLensDirection.back,
          ),
        ],
      ),
    );
  }

  void _onControllerCreated(_, Exception? error) {
    if (error != null) {
      // Handle permission or unknown errors
      _showMessage(context, 'Error: $error');
    }
  }

  _onScanSuccess(Code? code) {
    setState(() {
      successScans++;
      result = code;
    });
  }

  _onScanFailure(Code? code) {
    setState(() {
      failedScans++;
      result = code;
    });
    if (code?.error?.isNotEmpty == true) {
      _showMessage(context, 'Error: ${code?.error}');
    }
  }

  _onMultiScanSuccess(Codes codes) {
    setState(() {
      successScans++;
      multiResult = codes;
    });
  }

  _onMultiScanFailure(Codes result) {
    setState(() {
      failedScans++;
      multiResult = result;
    });
    if (result.codes.isNotEmpty == true) {
      _showMessage(context, 'Error: ${result.codes.first.error}');
    }
  }

  _onMultiScanModeChanged(bool isMultiScan) {
    setState(() {
      this.isMultiScan = isMultiScan;
    });
  }

  _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  _onReset() {
    setState(() {
      successScans = 0;
      failedScans = 0;
    });
  }
}
