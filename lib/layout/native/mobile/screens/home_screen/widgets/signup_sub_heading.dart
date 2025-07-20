import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/signup_screen/signup.dart';
class SignupSubHeading extends StatelessWidget {
  const SignupSubHeading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark=isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "prepare your order",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: isDark?Colors.white:Color(0xFF32343E),
          ),
        ),
        //subtitle
        SizedBox(height: 12),
        Text(
          "If you don’t have an account",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: isDark?Colors.white:Color(0xFF646982),
          ),
        ),
        Row(
          children: [
            Text(
              "Please",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: isDark?Colors.white:Color(0xFF646982),
              ),
            ),
            GestureDetector(
              onTap: ()=>Get.to(SignupScreen()),
              child: Text(
                " Sign up here",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color(0xFFF44336),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

