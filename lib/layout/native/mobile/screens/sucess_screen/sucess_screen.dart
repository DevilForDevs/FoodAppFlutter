import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_button.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/orders_screen/orders_screen.dart';

import '../banner_ad_widget.dart';

class SucessScreen extends StatelessWidget {
  const SucessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);


    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "",
          leading_icon: Icons.clear,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(
                width: 160,
                height: 160,
                image: AssetImage("assets/sucessconfti.png"),
              ),
              const SizedBox(height: 20),
              Text(
                "Congratulations!",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: "Sen-SemiBold",
                  color: isDark ? Colors.white : Color(0xFF1A1817),
                ),
              ),
              const Text(
                "You successfully made a payment,\n enjoy our service! 👍",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFB0A9A2),
                  fontSize: 16,
                  fontFamily: "Sen-Regular",
                ),
              ),
              const SizedBox(height: 20),
              CustomActionButton(
                label: "Go To Orders",
                backgroundColor: Color(0xFFFF7622),
                onPressed: (){
                  Get.to(OrdersScreen());

                }
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 12), // Optional spacing
          child: const BannerAdWidget(), // 👈 Shows banner safely
        ),
      ),
    );
  }
}
