import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_button.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/orders_screen/orders_screen.dart';

import '../banner_ad_widget.dart';
import '../credentials_controller.dart';

class SucessScreen extends StatelessWidget {
  const SucessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    final controller=Get.find<CredentialController>();
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
              const SizedBox(height: 12),
              CustomActionButton(
                label: "Go To Orders",
                backgroundColor: Color(0xFFFF7622),
                onPressed: (){
                  Get.offAll(OrdersScreen());

                }
              ),
              SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Obx(
                          () => CircleAvatar(
                        radius: 40,
                        backgroundImage: controller.pickedImage.value != null
                            ? FileImage(controller.pickedImage.value!) // Use the picked image if available
                            : AssetImage('assets/person.png') as ImageProvider, // Use the default image if not
                      ),
                    ),
                  ),
                  SizedBox(width: 20,),
                  Text(
                    controller.name.value,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 16), // Optional spacing
          child: const BannerAdWidget(), // 👈 Shows banner safely
        ),
      ),
    );
  }
}
