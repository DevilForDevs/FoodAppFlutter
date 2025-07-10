import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/verify_email/verify_controller.dart';

class WhatsAppOtpField extends StatelessWidget {
  final controller = Get.put(VerifyEmailController());
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        return SizedBox(
          width: 40,
          child: TextField(
            controller: controller.textControllers[index],
            focusNode: controller.focusNodes[index],
            maxLength: 1,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              counterText: "",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF868686), width: 1.5),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF868686), width: 2),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 3) {
                FocusScope.of(context).requestFocus(controller.focusNodes[index + 1]);
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).requestFocus(controller.focusNodes[index - 1]);
              }
              controller.otp[index].value = int.tryParse(value);
            },
          ),
        );
      }),
    );
  }
}
