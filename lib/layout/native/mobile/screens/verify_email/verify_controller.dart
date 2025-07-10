import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class VerifyEmailController extends GetxController {
  var obscureText = false.obs;

  // OTP digits as RxnInt (nullable int)
  var otp = List.generate(4, (_) => RxnInt());

  // FocusNodes and TextEditingControllers for OTP fields
  var focusNodes = List.generate(4, (_) => FocusNode());
  var textControllers = List.generate(4, (_) => TextEditingController());

  /// Optional: Combine OTP digits into a single int or string
  String get fullOtp => otp.map((digit) => digit.value?.toString() ?? '').join();
}
