import 'package:flutter/material.dart';

import '../../../../../comman/sys_utilities.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title, this.endWidget,
    this.leading_icon=Icons.arrow_back_ios_new_rounded,

  });

  final String title;
  final Widget? endWidget;
  final IconData? leading_icon;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 1.2); // Custom height

  @override
  Widget build(BuildContext context) {
    final isDark=isDarkMode(context);
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark?Color(0xFF303030):Color(0xFFECF0F4),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                leading_icon,
                color: isDark?Colors.white:Colors.black,
                size: 16,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style:TextStyle(
              fontSize: 14,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w400,
              color: isDark?Colors.white:Color(0xFF181C2E),
            ),
          ),
          const Spacer(),
          if (endWidget != null) endWidget!, // ✅ Correct conditional rendering
        ],
      ),
    );
  }
}
