import 'package:flutter/material.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({
    super.key,
    required this.page,
  });

  final Map<String, String> page;

  @override
  Widget build(BuildContext context) {
    final isDark=isDarkMode(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset(
            page["image"]!,
            width: 262,
            height: 304,
          ),
          const SizedBox(height: 20),
          Text(
            page["title"]!,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontFamily: "Poppins",
            ),
          ),
          const SizedBox(height: 24),
          Text(
            page["subtitle"]!,
            style: TextStyle(
              fontSize: 16,
              color:isDark?Colors.white: Color(0xFF646982),
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

        ],
      ),
    );
  }
}