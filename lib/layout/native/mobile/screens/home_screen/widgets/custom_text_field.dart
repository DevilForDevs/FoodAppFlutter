import 'package:flutter/material.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.obsecureText,
    required this.obsecureText_,
    required this.showTrailing, required this.hint_text, required this.text_controller,
  });
  final bool obsecureText;
  final VoidCallback obsecureText_;
  final bool showTrailing;
  final String hint_text;
  final TextEditingController text_controller;

  @override
  Widget build(BuildContext context) {
    // Create or find controller by tag
    final isDark=isDarkMode(context);

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark?Color(0xFF303030): Color(0xFFEBEBEB),
        border: Border.all(color: isDark ? const Color(0xFF424242):const Color(0xFFDEDEDE)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              obscureText: obsecureText,
              controller: text_controller,
              style: const TextStyle(fontSize: 14, color:Color(0xFF939393)),
              decoration:  InputDecoration(
                border: InputBorder.none,
                hintText:hint_text,
                hintStyle: TextStyle(color:Color(0xFF939393), fontSize: 14),
                isCollapsed: true,
              ),
              cursorColor: Color(0xFF939393),
            ),
          ),
          if (showTrailing)
            IconButton(
              onPressed: obsecureText_,
              icon: Icon(obsecureText ? Icons.visibility_off : Icons.visibility),
            ),
        ],
      ),
    );
  }
}
