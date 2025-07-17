import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../../../comman/networkings.dart';

class VerifyEmailController extends GetxController {
  var obscureText = false.obs;
  var retry=1.obs;

  // OTP digits as RxnInt (nullable int)
  var otp = List.generate(4, (_) => RxnInt());

  RxInt countdown = 60.obs;
  Timer? _timer;

  // FocusNodes and TextEditingControllers for OTP fields
  var focusNodes = List.generate(4, (_) => FocusNode());
  var textControllers = List.generate(4, (_) => TextEditingController());

  /// Optional: Combine OTP digits into a single int or string
  String get fullOtp => otp.map((digit) => digit.value?.toString() ?? '').join();
  @override
  void onInit() {
    super.onInit();
    startCountdown();

  }
  void startCountdown({VoidCallback? onFinished}) {
    // Cancel previous timer if any
    _timer?.cancel();

    countdown.value = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        timer.cancel();
        onFinished?.call(); // trigger callback when countdown ends
      }
    });
  }
  Future<void> sendOtpAgain(String email) async {
    final response = await sendOtp(email, "new");
    if (response.containsKey('otp')) {
      Fluttertoast.showToast(
        msg: "Otp sent",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16.0,
      );
      startCountdown();
    } else {
      Fluttertoast.showToast(
        msg: response["error message"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16.0,
      );
    }
  }
}
