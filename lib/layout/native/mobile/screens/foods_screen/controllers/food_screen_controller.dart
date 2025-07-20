

import 'dart:convert';


import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:jalebi_shop_flutter/comman/networkings.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/credentials_controller.dart';

import 'package:jalebi_shop_flutter/layout/native/mobile/screens/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../commans/database.dart';

class FoodScreenController extends GetxController {
  final products = <ProductModel>[].obs;
  late CredentialController credentialController;
  @override
  Future<void> onInit() async {
    super.onInit();
    credentialController=Get.put(CredentialController());
    loadItems();
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
