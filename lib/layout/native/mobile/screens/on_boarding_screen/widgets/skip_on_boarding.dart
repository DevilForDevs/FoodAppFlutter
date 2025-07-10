import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/home_screen/home_screen.dart';
class SkipButtonOnBoarding extends StatelessWidget {
  const SkipButtonOnBoarding({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark=isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed:()=>Get.to(const HomeScreen()),
          child:Text(
            "Skip",
            style: TextStyle(
                fontSize: 16,
                color: isDark?Colors.white:Colors.black,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400
            ),
          ),
        ),
      ),
    );
  }
}
