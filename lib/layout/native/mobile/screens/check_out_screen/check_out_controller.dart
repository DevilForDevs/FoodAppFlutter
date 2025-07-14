import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CheckoutController extends GetxController {
  final selectedPaymentMethod = 'cod'.obs;

  late Razorpay _razorpay;
  Razorpay get razorpay => _razorpay;

  /// Callbacks for payment events
  final void Function(PaymentSuccessResponse)? onSuccess;
  final void Function(PaymentFailureResponse)? onFailure;


  /// Constructor with optional callbacks
  CheckoutController({
    this.onSuccess,
    this.onFailure,

  });

  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': 2000,
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
    onSuccess?.call(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    onFailure?.call(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("externla wallent not");
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }
}

