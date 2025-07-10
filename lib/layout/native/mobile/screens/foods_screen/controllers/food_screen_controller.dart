import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/networkings.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/address_model.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/product_model.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/profile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  }
  Future<void> setUpProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final credentials = prefs.getString('credentials');
    if (credentials != null) {
      final decodedJson = jsonDecode(credentials);
      userId = decodedJson["user"]["id"].toString();
      accountType=decodedJson["user"]["account_type"];
      token = decodedJson["token"];

      subController.name.value = decodedJson["user"]["name"];

      // Use a user-specific cache key
      final cacheKey = 'cached_address_$userId';

      String? cachedAddressJson = prefs.getString(cacheKey);
      Map<String, dynamic> address;

      if (cachedAddressJson != null) {
        address = jsonDecode(cachedAddressJson);
        print('Loaded address from cache for user $userId.');
      } else {
        address = await getAddress(userId, token);
        await prefs.setString(cacheKey, jsonEncode(address));
        print('Fetched address from API and cached for user $userId.');
      }

      final addresses = address["addresses"] as List;
      final lastAddress = addresses.isNotEmpty ? addresses.last : null;
      subController.addresModel=AddressModel.fromJson(lastAddress);
    } else {
      print('No credentials found.');
    }
  }

  Future<void> loadItems() async {
    final result=await getRestrictedItems(userId, token);
    if (result is List) {
      for (var item in result) {
        products.add(ProductModel(name: item["name"], thumbnail: item["image_url"], price: item["price"], isFavourite: false, about:item["description"],unit: item["unit"]));
      }
    } else if (result is Map && result.containsKey('error_message')) {
      print("Error: ${result['error_message']}");
    }

  }
  





}
