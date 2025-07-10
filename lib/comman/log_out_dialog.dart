import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/home_screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Log Out'),
      content: Text('Are you sure you want to log out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();
            showLoadingDialog(context);
            await logout(context);
            hideLoadingDialog(context);
            Get.to(HomeScreen());
          },
          child: Text('Log Out'),
        ),
      ],
    ),
  );
}

Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final credentials = prefs.getString('credentials');
  if(credentials!=null){
    final decodedJson = jsonDecode(credentials);
    final cacheKey = 'cached_address_${decodedJson["user"]["id"].toString()}';
    await prefs.remove('credentials');
    await prefs.remove(cacheKey);
    Get.to(HomeScreen());
  }

}
void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white, // 🔷 Dialog background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: Row(
        children: [
          CircularProgressIndicator(
            color: Colors.orange, // 🔶 Spinner color
          ),
          const SizedBox(width: 16),
          Text(
            "Preparing...",
            style: TextStyle(
              color: Colors.black,     // 🔵 Text color
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  );
}

void hideLoadingDialog(BuildContext context) {
  Navigator.of(context).pop(); // Closes the dialog
}


