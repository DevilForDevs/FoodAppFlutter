import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/profile_list_item.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/credentials_controller.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/settings_screen/theme_controller.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    final credentialController=Get.find<CredentialController>();

    final isDark=isDarkMode(context);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Settings"),
        body:Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              ProfileListItem(
                icon: isDark ? Icons.light_mode : Icons.dark_mode,
                iconColor: Color(0xFFFB6F3D),
                title: isDark ? "Switch to Light Mode" : "Switch to Dark Mode",
                onTap: () {
                  themeController.toggleTheme();
                },
              ),
              SizedBox(height: 12),
              ProfileListItem(
                icon: Icons.delete,
                iconColor: Color(0xFFFB6F3D),
                title: "Delete Account",
                onTap: () {
                  if(credentialController.isQrSignIN.value){
                    Fluttertoast.showToast(
                      msg: "You are not authorized to delete account",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                    );
                  }else{
                    themeController.delete_Account(context);
                  }

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

