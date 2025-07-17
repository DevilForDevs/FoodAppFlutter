import 'package:flutter/material.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
class ProfileListItem extends StatelessWidget {
  const ProfileListItem({
    super.key, required this.icon, required this.iconColor, required this.title, required this.onTap,
  });
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark=isDarkMode(context);
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration:  BoxDecoration(
            color: isDark?Color(0xFF212121):Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(icon,color:iconColor),
        ),
        SizedBox(width: 16,),
        Text(
          title,
          style: TextStyle(
              color:isDark?Colors.white: Color(0xFF1A1817),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: "Sen"
          ),
        ),
        Spacer(),
        IconButton(icon:Icon(Icons.arrow_forward_ios,size: 18,),onPressed:onTap ,)
      ],
    );
  }
}
