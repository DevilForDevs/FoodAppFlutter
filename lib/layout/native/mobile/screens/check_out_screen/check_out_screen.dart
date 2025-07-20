import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/credentials_controller.dart';
import '../commans/custom_app_bar.dart';
import 'check_out_controller.dart';


class CheckOutScreen extends StatelessWidget {
  const CheckOutScreen({super.key, required this.payFailure, required this.paySuccess, required this.totalPrice});
  final void Function(String transactionId) paySuccess;
  final VoidCallback payFailure;
  final int totalPrice;

  @override
  Widget build(BuildContext context) {
    final credentialController=Get.find<CredentialController>();
    final controller = Get.put(
      CheckoutController(
        onSuccess: (response) {
          paySuccess(response.paymentId ?? '');
        },
        onFailure: (response) {
          payFailure();
        },
      ),
    );
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Checkout"),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  Text("Total Price:",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Text("₹$totalPrice",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 24),
              const Text("Select Payment Method",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Obx(() => RadioListTile<String>(
                title: const Text("Cash on Delivery"),
                value: 'cod',
                groupValue: controller.selectedPaymentMethod.value,
                onChanged: (value) =>
                    controller.selectPaymentMethod(value!),
              )),
              Obx(() => RadioListTile<String>(
                title: const Text("UPI / Razorpay"),
                value: 'upi',
                groupValue: controller.selectedPaymentMethod.value,
                onChanged: (value) =>
                    controller.selectPaymentMethod(value!),
              )),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.selectedPaymentMethod.value == 'cod') {
                       paySuccess("cod");
                    } else {
                       if(credentialController.accountType.value=="individual"){
                         controller.openCheckout();
                       }else{
                         Fluttertoast.showToast(
                           msg: "Online Payment Not Available For this account",
                           toastLength: Toast.LENGTH_SHORT,
                           gravity: ToastGravity.BOTTOM,
                           fontSize: 16.0,
                         );
                       }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF7622),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Pay",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
