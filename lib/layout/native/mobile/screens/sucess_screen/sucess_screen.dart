import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_button.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/orders_screen/orders_screen.dart';

class SucessScreen extends StatelessWidget {
  const SucessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "",
          leading_icon: Icons.clear,
        ),
        body: Center( // ✅ This centers the entire Column on screen
          child: Column(
            mainAxisSize: MainAxisSize.min, // Shrink to content
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(
                width: 160,
                height: 160,
                image: AssetImage("assets/sucessconfti.png"),
              ),
              const SizedBox(height: 20),
              const Text("Congratulations!", style: TextStyle(fontSize: 24,fontFamily: "Sen-SemiBold",color: Color(0xFF1A1817))),
              const Text(
                "You successfully maked a payment,\n enjoy our service!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFB0A9A2),
                  fontSize: 16,
                  fontFamily: "Sen-Regular"
                ),
              ),
              const SizedBox(height: 20),
              CustomActionButton(label: "Go To Orders",backgroundColor: Color(0xFFFF7622), onPressed: ()=>Get.to(OrdersScreen()))
            ],
          ),
        ),
      ),
    );
  }
}
