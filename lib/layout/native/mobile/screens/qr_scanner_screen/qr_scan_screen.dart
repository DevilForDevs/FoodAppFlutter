import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});
  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR")),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          final barcode = capture.barcodes.first;
          final String code = barcode.rawValue ?? "---";
          if (code.startsWith("shop_user_id:")) {
            final userId = code.split(":")[1];
            debugPrint("🧾 Scanned User ID: $userId");
            // You can now use this userId
          } else {
            debugPrint("❌ Unknown QR code: $code");
          }
        },
      ),
    );
  }
}