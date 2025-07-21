import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jalebi_shop_flutter/comman/log_out_dialog.dart';
import 'package:jalebi_shop_flutter/comman/networkings.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/foods_screen/food_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        onDetect: (capture) async {
          final barcode = capture.barcodes.first;
          final String code = barcode.rawValue ?? "---";
          if(code.contains(",")){
            List<String> parts =code.split(',');
            String userId = parts[0].trim();
            String name = parts.sublist(1).join(',').trim();
            showLoadingDialog(context);
            final response=await qrLogin(int.parse(userId), name);
            if(response.contains("token")){
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('credentials', response); // s
              await prefs.setBool('is_qr_login', true);
              Get.offAll(FoodScreen());
            }else{
              Get.back();
              Fluttertoast.showToast(
                msg:"Login Failed",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                fontSize: 16.0,
              );
              Get.back();

            }
          }
        },
      ),
    );
  }
}