import 'package:flutter/material.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
class AuthTextFieldHeading extends StatelessWidget {
  const AuthTextFieldHeading({
    super.key, required this.hint,
  });
  final String hint;

  @override
  Widget build(BuildContext context) {
    final isDark=isDarkMode(context);
    return Text(
      hint,
      style: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: isDark?Colors.white:Color(0xFF0D0D0D),
      ),
    );
  }
}