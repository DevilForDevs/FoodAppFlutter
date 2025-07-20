import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/personal_info_screen/personal_info_controller.dart';


class UploadProgressDialog extends StatelessWidget {
  const UploadProgressDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final PersonalInfoController controller = Get.find();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          final progress = controller.mProgress.value;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Uploading...", style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              LinearProgressIndicator(value: progress/100),
              SizedBox(height: 10),
              Text("${(progress * 100).toInt()}%"),
            ],
          );
        }),
      ),
    );
  }
}
