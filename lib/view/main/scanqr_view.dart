import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:meepay_app/utils/color_mp.dart';
import 'package:meepay_app/utils/scaffold_messger.dart';

class ScanQRCode extends StatefulWidget {
  const ScanQRCode({super.key, this.onCallBack});

  final ValueSetter<String>? onCallBack;

  @override
  State<ScanQRCode> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> {
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
      appBar: AppBar(
        backgroundColor: ColorMP.ColorPrimary,
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        title: const Text("Quét mã"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          ReaderWidget(
            onScan: _onScanSuccess,
            onScanFailure: _onScanFailure,
            onMultiScan: _onMultiScanSuccess,
            onMultiScanFailure: _onMultiScanFailure,
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
      showMessage(error.toString(), "99", 10);
    }
  }

  _onScanSuccess(Code? code) {
    if (code != null) {
      widget.onCallBack!(code.text.toString());
      Navigator.of(context).pop();
    }
  }

  _onScanFailure(Code? code) {
    setState(() {
      failedScans++;
      result = code;
    });
    if (code?.error?.isNotEmpty == true) {
      showMessage(code!.error!, "99", 10);
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
      showMessage(result.codes.first.error!, "99", 10);
    }
  }

  onReset() {
    setState(() {
      successScans = 0;
      failedScans = 0;
    });
  }
}
