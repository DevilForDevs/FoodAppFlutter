import 'package:flutter/material.dart';
import 'package:jalebi_shop_flutter/comman/profile_list_item.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark=isDarkMode(context);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Settings"),
        body: Container(
          decoration: BoxDecoration(
            color: isDark?Color(0xFF303030):Color(0xFFF0F5FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ProfileListItem(icon: isDark?Icons.light_mode:Icons.dark_mode, iconColor: Color(0xFFFB6F3D), title: isDark?"Switch Light Mode":"Switch Dark Mode", onTap: (){}),
                SizedBox(height: 12,),
                ProfileListItem(icon: Icons.delete, iconColor: Color(0xFFFB6F3D), title: "Delete Account", onTap: (){}),
              ],
            ),
          ),
        ),

      ),
    );
  }
}
