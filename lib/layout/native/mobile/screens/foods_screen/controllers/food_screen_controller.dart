import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/networkings.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/address_model.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/product_model.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/profile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../commans/database.dart';

class FoodScreenController extends GetxController {
  var categorySelectItem = 0.obs;
  final TextEditingController searchTextController = TextEditingController();
  late final ProfileController subController;
  final products=<ProductModel>[].obs;
  var accountType="";
  var userId="";
  var token="";
  @override
  Future<void> onInit() async {
    super.onInit();
    subController = Get.put(ProfileController());
    final muser=await setUpProfile();
    loadItems();
    fetchCartItems();

  }
  Future<void> setUpProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final credentials = prefs.getString('credentials');

    if (credentials != null) {
      final decodedJson = jsonDecode(credentials);
      userId = decodedJson["user"]["id"].toString();
      accountType = decodedJson["user"]["account_type"];
      token = decodedJson["token"];

      subController.name.value = decodedJson["user"]["name"];

      final addressJson = await getAddress(userId, token);
      final addressList = addressJson["addresses"] as List;

      // ✅ Use last address
      if (addressList.isNotEmpty) {
        subController.addresModel =AddressModel.fromJson(addressList.last);
      }
    } else {
      print('No credentials found.');
    }
  }


  Future<void> loadItems() async {
    final result=await getRestrictedItems(userId, token);
    if (result is List) {
      for (var item in result) {
        final mProduct=ProductModel(name: item["name"], thumbnail: item["image_url"], price: item["price"], isFavourite: false, about:item["description"],unit: item["unit"],item_id: item["id"]);
        products.add(mProduct);
      }
    } else if (result is Map && result.containsKey('error_message')) {
      print("Error: ${result['error_message']}");
    }

  }
  Future<void> fetchCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString("cart");

    if (cartJson != null) {
      final List<dynamic> cartList = jsonDecode(cartJson);
      subController.cartSize.value=cartList.length;

    }
  }

  





}
