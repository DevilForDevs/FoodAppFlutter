import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/addresses_list/address_screen_controller.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/sucess_screen/sucess_screen.dart';
import '../commans/custom_app_bar.dart';
import '../product_model.dart';
import 'check_out_controller.dart';


class CheckOutScreen extends StatelessWidget {
  CheckOutScreen({super.key, required this.food, required this.quantity, required this.addressScreenController});

  final controller = Get.put(CheckoutController());
  final ProductModel food;
  final int quantity;
  final AddressScreenController addressScreenController;



  @override
  Widget build(BuildContext context) {
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
                  Text("₹${quantity*food.price}",
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
                       addressScreenController.placeOrder(food, quantity, "cod");
                    } else {
                      controller.openCheckout();
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
