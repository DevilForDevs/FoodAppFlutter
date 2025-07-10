import 'dart:convert';

import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/address_screen/address_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../comman/networkings.dart';
import '../address_model.dart';


class AddressScreenController extends GetxController {
  // Observable list of addresses
  var addressList = <AddressModel>[].obs;
  var token="".obs;
  var userId="".obs;

  @override
  void onInit() {
    super.onInit();
    retriveAddresses();
  }
  Future<void> retriveAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final credentials = prefs.getString('credentials');

    if (credentials != null) {
      final decodedJson = jsonDecode(credentials);
      userId.value = decodedJson["user"]["id"].toString();
      token.value = decodedJson["token"];

      final cacheKey = 'cached_address_${userId.value}';

      String? cachedAddressJson = prefs.getString(cacheKey);
      Map<String, dynamic> address;

      if (cachedAddressJson != null) {
        address = jsonDecode(cachedAddressJson);
        print('Loaded address from cache for user ${userId.value}.');
      } else {
        address = await getAddress(userId.value, token.value);
        await prefs.setString(cacheKey, jsonEncode(address));
        print('Fetched address from API and cached for user ${userId.value}.');
      }

      // ✅ Parse and load into observable list
      final addresses = address["addresses"] as List<dynamic>;
      loadAddressesFromJson(addresses);
    } else {
      print('No credentials found.');
    }
  }

  // Example: remove an address by index
  void removeAddress(int index) {
    if (index >= 0 && index < addressList.length) {
      addressList.removeAt(index);
    }
  }

  void loadAddressesFromJson(List<dynamic> jsonList) {
    for (int i = 0; i < jsonList.length; i++) {
      addressList.add(AddressModel.fromJson(jsonList[i]));
    }
  }

  void editAddress(int index){
    Get.to(AddressScreen(addressModel: addressList[index]));

  }
}