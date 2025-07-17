import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/log_out_dialog.dart';

import 'package:jalebi_shop_flutter/comman/networkings.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/product_model.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/profile_controller.dart';
import 'package:path_provider/path_provider.dart';
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


  }
  Future<void> setUpProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final credentials = prefs.getString('credentials');

    if (credentials == null) {
      print('No credentials found.');
      return;
    }

    final decodedJson = jsonDecode(credentials);
    userId = decodedJson["user"]["id"].toString();
    accountType = decodedJson["user"]["account_type"];
    token = decodedJson["token"];

    subController.email.value = decodedJson["user"]["email"];
    subController.name.value = decodedJson["user"]["name"];
    subController.bio.value = decodedJson["user"]["bio"] ?? "fast food lover";

    String avatarPathOrUrl = decodedJson["user"]["avatar"];

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
          subController.pickedImage.value = file;

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
      subController.pickedImage.value = File(avatarPathOrUrl);
    }

    final addressJson = await getAddress(userId, token);
    final addressList = addressJson["addresses"] as List;

    if (addressList.isNotEmpty) {
      final lastAddress = addressList.last;
      subController.addresModel.street.value = lastAddress["street"];
      subController.addresModel.addressId.value = lastAddress["address_id"];
      subController.addresModel.userId.value = lastAddress["user_id"];
      subController.addresModel.city.value = lastAddress["city"];
      subController.addresModel.pincode.value = lastAddress["pincode"];
      subController.addresModel.longAddress.value = lastAddress["longAddress"];
      subController.addresModel.addressType.value = lastAddress["addressType"];
    }
  }


  Future<void> loadItems() async {

    showLoadingDialog(Get.context!);
    final result=await getAllItems(userId, token);
    if (result is List) {
      for (var item in result) {
        final isFavourite=await CartDatabase.isFavourite(item["id"]);
        final mProduct=ProductModel(name: item["name"], thumbnail: item["image_url"], price: item["price"], isFavourite: isFavourite, about:item["description"],unit: item["unit"],item_id: item["id"]);
        products.add(mProduct);
      }
      Get.back();
    } else if (result is Map && result.containsKey('error_message')) {
      print("Error: ${result['error_message']}");
      Get.back();
      Fluttertoast.showToast(
        msg: "Failed to Load Items",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16.0,
      );
    }

  }



}
