import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jalebi_shop_flutter/comman/log_out_dialog.dart';
import 'package:jalebi_shop_flutter/comman/networkings.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/foods_screen/food_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});
  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _isProcessing = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (_isProcessing) return;

      final code = scanData.code ?? '';
      if (code.contains(",")) {
        _isProcessing = true;
        controller.pauseCamera(); // avoid multiple scans
        List<String> parts = code.split(',');
        String userId = parts[0].trim();
        String name = parts.sublist(1).join(',').trim();

        showLoadingDialog(context);
        final response = await qrLogin(int.parse(userId), name);

        if (response.contains("token")) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('credentials', response);
          await prefs.setBool('is_qr_login', true);
          Get.offAll(FoodScreen());
        } else {
          Get.back(); // close loading
          Fluttertoast.showToast(
            msg: "Login Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0,
          );
          controller.resumeCamera();
          _isProcessing = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR")),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.green,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: 300,
        ),
      ),
    );
  }
}
