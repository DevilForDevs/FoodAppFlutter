import 'package:flutter/material.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
class TopHeadingSignup extends StatelessWidget {
  const TopHeadingSignup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark=isDarkMode(context);
    return Row(
      children: [
        Text(
          "Just",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color:isDark?Colors.white: Color(0xFF32343E),
          ),
        ),
        Text(
          " Sign in,",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color(0xFFF44336),
          ),
        ),
        Text(
          "we’ll",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: isDark?Colors.white:Color(0xFF32343E),
          ),
        ),
      ],
    );
  }
}
