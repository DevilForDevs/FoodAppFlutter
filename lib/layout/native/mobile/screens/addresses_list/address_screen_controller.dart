import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/address_screen/address_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/database.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/product_model.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/sucess_screen/sucess_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../comman/networkings.dart';
import '../address_model.dart';


class AddressScreenController extends GetxController {
  // Observable list of addresses
  var addressList = <AddressModel>[].obs;
  var token="".obs;
  var userId="".obs;
  var selectedAddressIndex=0.obs;
  final phone=TextEditingController();

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
  Future<void> placeOrder(ProductModel product,int quantity,String paymentMethod) async {
    final response= await addOrder(token.value, userId.value, addressList[selectedAddressIndex.value].addressId.value.toString(), product.item_id.toString(), phone.text, quantity, product.price, "cod");
    if(response.contains("successfully")){
      final inserted1=await DatabaseHelper.insertProduct(product);
      final inserted=await DatabaseHelper.insertOrderItem(userId: userId.value, address: "address", itemId: product.item_id, phone: phone.text, quantity: quantity, price: product.price, method: "cod", status: "pending", createdAt: "today");
      Get.off(() => SucessScreen());
    }
  }
}