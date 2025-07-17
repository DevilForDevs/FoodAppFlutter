import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jalebi_shop_flutter/comman/networkings.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/on_boarding_screen/on_boarding_screen.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  var isDark = false.obs;

  void toggleTheme() {
    isDark.value = !isDark.value;
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }
// Function to show confirmation dialog and delete account
  Future<void> delete_Account(BuildContext context) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Account"),
        content: Text("Are you sure you want to delete your account? This action cannot be undone."),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      final credentials = prefs.getString('credentials');

      if (credentials != null) {
        final decodedJson = jsonDecode(credentials);
        final authToken = decodedJson["token"];

        final response = await deleteAccount(authToken); // Replace with your API call
        if (response.contains("successfully")) {
          await prefs.clear(); // ✅ Delete all saved preferences

          Fluttertoast.showToast(
            msg: "Account Deleted",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0,
          );
          final dir = await getApplicationDocumentsDirectory(); // or getTemporaryDirectory()
          final path = join(dir.path, 'cart.db');

          final file = File(path);

          if (await file.exists()) {
            await file.delete();
            print('cart.db deleted');
          } else {
            print('cart.db does not exist');
          }

          Get.offAll(() => OnBoardingScreen());
        } else {
          Fluttertoast.showToast(
            msg: "Failed to delete account",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        }
      }
    }
  }

}
