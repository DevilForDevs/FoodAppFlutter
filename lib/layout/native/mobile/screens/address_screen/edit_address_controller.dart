import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../comman/networkings.dart';
import '../address_model.dart';

class EditAddressController extends  GetxController {
  final AddressModel address;
  EditAddressController(this.address);
  var longAddress=TextEditingController();
  var city=TextEditingController();
  var village=TextEditingController();
  var pinCode=TextEditingController();
  var addressId=0.obs;
  var token="".obs;
  var addressTypes = <String>[].obs;
  var selectedIndex = 0.obs;
  var userId="".obs;

  @override
  void onInit() {
    super.onInit();
    addressTypes.addAll(['Home', 'Office', 'School', 'Coaching']);
    retriveAddresses();
  }

  Future<void> saveAddress(BuildContext context) async {
    address.longAddress.value=longAddress.text;
    final response=await updateAddress(addressId.value.toString(),longAddress.text,city.text,pinCode.text,village.text,addressTypes[selectedIndex.value],token.value);
    if(response.toLowerCase().contains('successfully') == true){
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = 'cached_address_$userId';
      await prefs.remove(cacheKey);
      if (context.mounted) {
        Navigator.pop(context); // 👈 go back
      }
    }
  }
  Future<void> retriveAddresses()async{
    final prefs = await SharedPreferences.getInstance();
    final credentials = prefs.getString('credentials');
    if (credentials != null) {
      final decodedJson = jsonDecode(credentials);
      userId.value = decodedJson["user"]["id"].toString();
      token.value = decodedJson["token"];
      village.text =address.street.value;
      longAddress.text=address.longAddress.value;
      city.text=address.city.value;
      pinCode.text=address.pincode.value;
      addressId.value=address.addressId.value;
      for(String m in addressTypes){
        if(m==address.addressType.value){
          selectedIndex.value=addressTypes.indexOf(m);
        }
      }

    } else {
      print('No credentials found.');
    }
  }

}
