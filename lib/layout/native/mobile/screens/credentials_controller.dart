import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/database.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/place_order_screen/address_db.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/product_model.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/sucess_screen/sucess_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../comman/log_out_dialog.dart';
import '../../../../comman/networkings.dart';
import 'check_out_screen/check_out_screen.dart';
class CredentialController extends GetxController{
  final name="".obs;
  final addressId=0.obs;
  final Rx<File?> pickedImage = Rx<File?>(null);
  final longAddress="Address".obs;
  final village="Village".obs;
  var token = "".obs;
  final cartSize=0.obs;
  final bio="Fast Food lover".obs;
  late var userId="";
  final addresses=<Address>[].obs;
  final RxInt selectedAddressIndex=0.obs;
  final phone=TextEditingController();
  final email="".obs;
  final accountType="".obs;
  final isQrSignIN=false.obs;



  @override
  Future<void> onInit() async {
    super.onInit();
    final prefs = await SharedPreferences.getInstance();
    final credentials = prefs.getString('credentials');
     isQrSignIN.value = prefs.getBool('is_qr_login') ?? false;
    if (credentials != null) {
      final decodedJson = jsonDecode(credentials);
      name.value=decodedJson["user"]["name"];
      token.value=decodedJson["token"];
      String avatarPathOrUrl = decodedJson["user"]["avatar"];
      email.value=decodedJson["user"]["email"];
      userId = decodedJson["user"]["id"].toString();
      print(decodedJson["user"]);
      accountType.value=decodedJson["user"]["account_type"];
      if (avatarPathOrUrl.startsWith('http')) {
        final progress = ValueNotifier<double>(0);

        // Show progress dialog
        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: Text('Downloading Avatar...'),
            content: ValueListenableBuilder<double>(
              valueListenable: progress,
              builder: (context, value, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(value: value),
                    SizedBox(height: 12),
                    Text('${(value * 100).toStringAsFixed(1)}%'),
                  ],
                );
              },
            ),
          ),
        );
        try{
          final uri = Uri.parse(avatarPathOrUrl);
          final directory = await getApplicationDocumentsDirectory();
          final filePath = '${directory.path}/avatar_$userId.jpg';
          final downloadedPath = await downloadFile(
            avatarPathOrUrl,
            savePath: filePath,
            onProgress: (percent) => progress.value = percent.toDouble(),
          );
          if (downloadedPath != null) {
            final file = File(downloadedPath);
            pickedImage.value = file;

            // ✅ Update SharedPreferences with local avatar path
            decodedJson["user"]["avatar"] = filePath;
            await prefs.setString('credentials', jsonEncode(decodedJson));
          } else {
            print("Failed to download avatar.");
          }
        }catch(e){
          print(e.toString());
        }finally {
          Get.back(); // ✅ Close progress dialog
        }

      } else {
        pickedImage.value = File(avatarPathOrUrl);
      }
      final addressList=await AddressDbHelper.getAllAddresses();
      if(addressList.isEmpty){
        final addressJson = await getAddress(userId, token.value);
        final addressList = addressJson["addresses"] as List;
        for(var address in addressList){
          AddressDbHelper.insertAddress(Address.fromMap(address));
          addresses.add(Address.fromMap(address));
        }
        if(addressList.isNotEmpty){
          final lastAddress=addressList.last;
          longAddress.value=lastAddress["longAddress"];
          village.value=lastAddress["street"];
          selectedAddressIndex.value=addressList.length-1;
        }
      }else{
        for(Address adr in addressList){
          addresses.add(adr);
        }
        final lastAddress=addresses.last;
        longAddress.value=lastAddress.longAddress;
        village.value=lastAddress.street;
        selectedAddressIndex.value=addressList.length-1;
      }

    }
    final cartItems = await CartDatabase.getCartItems();
    cartSize.value=cartItems.length;

  }
  void changeSelectedIndex(int index){
    selectedAddressIndex.value=index;
  }
  Future<String> placeOrder(ProductModel product,int quantity,String paymentMethod) async {
    final response= await addOrder(token.value, userId,addresses[selectedAddressIndex.value].addressId.toString(), product.item_id.toString(), phone.text, quantity, product.price, paymentMethod);
    return response;
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

      if(phone.text.isNotEmpty){
        final mobileRegex = RegExp(r"^(0|91)?[6-9][0-9]{9}$");

        if (mobileRegex.hasMatch(phone.text)) {

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
            final isOrderPlaced=await placeOrder(food, quantity, tId);
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