

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/log_out_dialog.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/credentials_controller.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/place_order_screen/address_db.dart';

import '../../../../../comman/networkings.dart';


class EditAddressController extends  GetxController {
  final int addressIndex;
  EditAddressController(this.addressIndex);
  var LongAddress=TextEditingController();
  var city=TextEditingController();
  var village=TextEditingController();
  var pinCode=TextEditingController();
  var token="".obs;
  var addressTypes = <String>[].obs;
  var selectedIndex = 0.obs;
  var userId=0.obs;
  late CredentialController credentialController;
  final pinRegex = RegExp(r"^[1-9][0-9]{2}\s?[0-9]{3}$");

  @override
  void onInit() {
    super.onInit();
    addressTypes.addAll(['Home', 'Office', 'School', 'Coaching']);
    credentialController=Get.find<CredentialController>();
    token.value=credentialController.token.value;
    userId.value=int.tryParse(credentialController.userId)!;
    if(addressIndex>-1){
      LongAddress.text=credentialController.addresses[addressIndex].longAddress;
      city.text=credentialController.addresses[addressIndex].city;
      village.text=credentialController.addresses[addressIndex].street;
      pinCode.text=credentialController.addresses[addressIndex].pincode;
      for(String adt in addressTypes){
        if(adt==credentialController.addresses[addressIndex].addressType){
          selectedIndex.value=addressTypes.indexOf(adt);
        }
      }

    }

  }
  Future<void> saveAddress() async {
    if(credentialController.accountType.value=="individual"){
      showLoadingDialog(Get.context!);
      if(pinRegex.hasMatch(pinCode.text)){
        if(addressIndex==-1){
          final response=await addAddress(LongAddress.text,city.text,pinCode.text,village.text,addressTypes[selectedIndex.value],token.value);
          if(response.contains("successfully")){
            final responseJson=jsonDecode(response);
            final newAddress=Address(userId: userId.value, city: city.text, street: village.text, pincode: pinCode.text, longAddress: LongAddress.text, addressType: addressTypes[selectedIndex.value], addressId: responseJson["address_id"]);
            AddressDbHelper.insertAddress(newAddress);
            credentialController.addresses.add(newAddress);
            Get.back();
            Get.back();
          }else{
            Fluttertoast.showToast(
              msg: "Failed to add address",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              fontSize: 16.0,
            );
            Get.back();
          }
        }else{

          final address=credentialController.addresses[addressIndex];
          final addressEdit=Address(userId: userId.value, city: city.text, street: village.text, pincode: pinCode.text, longAddress: LongAddress.text, addressType: addressTypes[selectedIndex.value], addressId: address.addressId);
          final response=await updateAddress(address.addressId.toString(),LongAddress.text,city.text,pinCode.text,village.text,addressTypes[selectedIndex.value],credentialController.token.value);


          if(response.contains("successfully")){
            AddressDbHelper.updateAddress(addressEdit);
            int index = credentialController.addresses.indexWhere(
                  (addressItem) => addressItem.addressId == address.addressId,
            );
            if (index != -1) {
              credentialController.addresses[index] = addressEdit;
            }
            Get.back();
            Get.back();
          }else{
            Fluttertoast.showToast(
              msg: "Failed to update address",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              fontSize: 16.0,
            );
            Get.back();
          }

        }
      }
    }else{
      Fluttertoast.showToast(
        msg: "Account not support Address Editing",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16.0,
      );
    }


  }


}
