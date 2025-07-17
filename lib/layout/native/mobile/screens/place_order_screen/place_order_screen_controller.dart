import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/place_order_screen/address_db.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../comman/networkings.dart';
class PlaceOrderScreenController extends GetxController {
  var addressList = <Address>[].obs;
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
      final response = await getAddress(userId.value, token.value);

      final List<dynamic> items = response["addresses"];

      for (var item in items) {
        addressList.add(Address.fromMap(item));
      }


    } else {
      print('No credentials found.');
    }
  }
}