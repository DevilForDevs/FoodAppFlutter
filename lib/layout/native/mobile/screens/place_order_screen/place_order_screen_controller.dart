import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/place_order_screen/address_db.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../comman/log_out_dialog.dart';
import '../../../../../comman/networkings.dart';
import '../check_out_screen/check_out_screen.dart';
import '../credentials_controller.dart';
import '../sucess_screen/sucess_screen.dart';
class PlaceOrderScreenController extends GetxController {
  var addressList = <Address>[].obs;
  var token="".obs;
  var userId="".obs;
  var selectedAddressIndex=0.obs;
  final phone=TextEditingController();
  late CredentialController credentialController;
  @override
  void onInit() {
    super.onInit();
    credentialController=Get.find<CredentialController>();
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
  Future<void> mplaceOrder( ProductModel food,int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("pending_order")){
      Fluttertoast.showToast(
        msg: "You have already a pending order",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16.0,
      );
    }else{
      if(credentialController.phone.text.isNotEmpty){
        final mobileRegex = RegExp(r"^(0|91)?[6-9][0-9]{9}$");

        if (mobileRegex.hasMatch(credentialController.phone.text)) {

          Get.to(CheckOutScreen( totalPrice:food.price,payFailure: (){
            Fluttertoast.showToast(
              msg: "Payment Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              fontSize: 16.0,
            );
          }, paySuccess: (tId) async {
            Get.back();
            showLoadingDialog(Get.context!);
            final isOrderPlaced=await credentialController.placeOrder(food, quantity, tId);
            if(isOrderPlaced.contains("successfully")){
              Get.back();
              final isQrLogin = prefs.getBool('is_qr_login') ?? false;
              if (isQrLogin) {
                final mjson=jsonEncode({
                  "imageUrl":food.thumbnail,
                  "itemName":food.name
                });
                prefs.setString("pending_order",mjson);
                ///sound featured success screen
                Get.off(() => SucessScreen());
              }else{
                Get.off(() => SucessScreen());
              }

            }else{
              Get.back();
              Fluttertoast.showToast(
                msg: "Failed to place order",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                fontSize: 16.0,
              );
            }

          }));
        } else {
          Fluttertoast.showToast(
            msg: "Invalid mobile number",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0,
          );
        }

      }else{
        Fluttertoast.showToast(
          msg: "Phone Number is required",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16.0,
        );
      }
    }
  }
}