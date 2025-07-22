import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/home_screen/home_screen.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

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
            Get.back();
            final dir = await getApplicationDocumentsDirectory();
            final path = join(dir.path, 'cart.db');
            final file = File(path);

            if (await file.exists()) {
              await file.delete();
              final prefs = await SharedPreferences.getInstance();
              prefs.remove("credentials");
              prefs.remove("pending_order");
              prefs.remove("is_qr_login");
              final deleted=deleteDatabaseFiles();
              Get.offAll(HomeScreen());
            } else {
              print('cart.db does not exist.');
            }
            Get.to(HomeScreen());
          },
          child: Text('Log Out'),
        ),
      ],
    ),
  );
}
Future<void> deleteDatabaseFiles() async {
  try {
    // cart.db path
    final dir = await getApplicationDocumentsDirectory();
    final cartDbPath = join(dir.path, 'cart.db');

    // address.db path
    final dbPath = await getDatabasesPath();
    final addressDbPath = join(dbPath, 'address.db');

    // Delete cart.db if it exists
    final cartDbFile = File(cartDbPath);
    if (await cartDbFile.exists()) {
      await cartDbFile.delete();
      print('Deleted cart.db');
    }

    // Delete address.db if it exists
    final addressDbFile = File(addressDbPath);
    if (await addressDbFile.exists()) {
      await addressDbFile.delete();
      print('Deleted address.db');
    }
  } catch (e) {
    print('Error deleting database files: $e');
  }
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


