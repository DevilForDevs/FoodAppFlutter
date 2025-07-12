import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CheckoutController extends GetxController {
  final selectedPaymentMethod = 'cod'.obs;

  late Razorpay _razorpay;

  Razorpay get razorpay => _razorpay;

  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay(); // ✅ Make sure it's initialized here
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  void openCheckout() {
    // ✅ Make sure _razorpay is initialized before this
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag', // Razorpay test key
      'amount': 2000, // in paise (₹20)
      'name': 'Jalebi Shop',
      'description': 'Order Payment',
      'prefill': {'contact': '9999999999', 'email': 'test@jalebi.shop'},
      'external': {'wallets': ['paytm']},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      Get.snackbar("Error", "Unable to start Razorpay: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Get.snackbar("Success", "Payment ID: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar("Failed", "Reason: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar("Wallet", "${response.walletName}");
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }
}
