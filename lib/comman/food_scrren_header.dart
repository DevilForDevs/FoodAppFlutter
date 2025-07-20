import 'package:flutter/material.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/credentials_controller.dart';
import 'package:get/get.dart';
class FoodScreenHeader extends StatelessWidget {
  const FoodScreenHeader({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final conroller=Get.find<CredentialController>();
    return Row(
      children: [
        Text(
          "Hey ${conroller.name.value},",
          style: TextStyle(
              fontSize: 16

          ),
        ),
        Text(
          " Good Afternoon!",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: "Poppins"

          ),

        )
      ],
    );
  }
}