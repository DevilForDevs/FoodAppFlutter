import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/cart_screen/cart_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/credentials_controller.dart';

class TopBarCartButton extends StatelessWidget {
  const TopBarCartButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CredentialController>();

    return GestureDetector(
      onTap: () => Get.to(CartScreen()),
      child: Obx(()=>Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              height: 40,
              width: 40,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF181C2E),
                shape: BoxShape.circle,
              ),
              child: Image(image: AssetImage("assets/shopping-bag.png")),
            ),
            if (controller.cartSize.value > 0)
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Color(0xFFFF7622),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "${controller.cartSize.value}",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
