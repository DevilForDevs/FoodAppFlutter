import 'package:flutter/material.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/profile_controller.dart';
class FoodScreenHeader extends StatelessWidget {
  const FoodScreenHeader({
    super.key, required this.controller,
  });
  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Hey ${controller.name},",
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