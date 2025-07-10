import 'package:flutter/material.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
class ForgotPassword extends StatelessWidget {
  const ForgotPassword({
    super.key, required this.onPress,
  });
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: onPress,
          child: Text(
            "Forgot password ?",
            style:TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Color(0xFF939393),
            ),
          ),
        )
      ],
    );
  }
}