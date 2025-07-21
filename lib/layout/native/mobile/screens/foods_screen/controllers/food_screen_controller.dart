

import 'dart:convert';
import 'dart:io';


import 'package:firebase_app_installations/firebase_app_installations.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:jalebi_shop_flutter/comman/networkings.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/credentials_controller.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/home_screen/home_screen.dart';

import 'package:jalebi_shop_flutter/layout/native/mobile/screens/product_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../commans/database.dart';

class FoodScreenController extends GetxController {
  final products = <ProductModel>[].obs;
  late CredentialController credentialController;
  @override
  Future<void> onInit() async {
    super.onInit();
    credentialController=Get.put(CredentialController());
    final itemsLoaded=await loadItems();
    final prefs = await SharedPreferences.getInstance();
    final isQrLogin = prefs.getBool('is_qr_login') ?? false;
    if (isQrLogin) {
      final pendingOrder = await _getPendingOrderData();
      if (pendingOrder != null) {
        Future.delayed(Duration.zero, () {
          Get.dialog(_buildPendingOrderDialog(pendingOrder));
        });
      }
    }


  }
  Widget _buildPendingOrderDialog(Map<String, dynamic> order) {
    return AlertDialog(
      title: const Text("ऑर्डर मिल गया?"), // Order received?
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(order['imageUrl'], height: 100), // item image
          const SizedBox(height: 8),
          Text("आइटम: ${order['itemName']}"), // Item name in Hindi
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final phone = "7632975366";
            launchUrl(Uri.parse("tel:$phone"));
          },
          child: const Text("मैनेजर को कॉल करें"), // Call Manager
        ),
        TextButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            prefs.remove("pending_order");
            prefs.remove("credentials");
            prefs.remove("is_qr_login");
            final deleted=deleteDatabaseFiles();
            Get.offAll(HomeScreen());

          },
          child: const Text("हाँ"), // Yes
        ),
      ],
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


  Future<Map<String, dynamic>?> _getPendingOrderData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('pending_order')) {
      final jsonString = prefs.getString('pending_order');
      if (jsonString != null) {
        return json.decode(jsonString);
      }
    }
    return null;
  }
  Future<void> loadItems() async {

    final prefs = await SharedPreferences.getInstance();
    final credentials = prefs.getString('credentials');
    if (credentials != null) {
      final decodedJson = jsonDecode(credentials);
      if(credentialController.accountType.value=="individual"){
        final result = await getAllItems(decodedJson["token"]);
        if (result is List) {
          for (var item in result) {
            final isFavourite = await CartDatabase.isFavourite(item["id"]);
            final mProduct = ProductModel(
              name: item["name"],
              thumbnail: item["image_url"],
              price: item["price"],
              isFavourite: isFavourite,
              about: item["description"],
              unit: item["unit"],
              item_id: item["id"],
            );
            products.add(mProduct);
          }

        } else if (result is Map && result.containsKey('error_message')) {
          print("Error: ${result['error_message']}");

          Fluttertoast.showToast(
            msg: "Failed to Load Items",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0,
          );
        }
      }else{
        final result = await getRestrictedItems(decodedJson["token"]);
        if (result is List) {
          for (var item in result) {
            final isFavourite = await CartDatabase.isFavourite(item["id"]);
            final mProduct = ProductModel(
              name: item["name"],
              thumbnail: item["image_url"],
              price: item["price"],
              isFavourite: isFavourite,
              about: item["description"],
              unit: item["unit"],
              item_id: item["id"],
            );
            products.add(mProduct);
          }
        } else if (result is Map && result.containsKey('error_message')) {
          print("Error: ${result['error_message']}");

          Fluttertoast.showToast(
            msg: "Failed to Load Items",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0,
          );
        }

      }


    }
    }


}
