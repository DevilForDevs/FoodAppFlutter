import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/place_order_screen/address_db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../networkings.dart';
class FoodScreenDrawerController extends  GetxController {
  final name="John".obs;
  final addressId=0.obs;
  final Rx<File?> pickedImage = Rx<File?>(null);
  final longAddress="Address".obs;
  var token = "".obs;
  
  
  @override
  Future<void> onInit() async {
    super.onInit();
    final prefs = await SharedPreferences.getInstance();
    final credentials = prefs.getString('credentials');
    if (credentials != null) {
      final decodedJson = jsonDecode(credentials);
      name.value=decodedJson["user"]["name"];
      token.value=decodedJson["token"];
      String avatarPathOrUrl = decodedJson["user"]["avatar"];
      final userId = decodedJson["user"]["id"].toString();
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
        }
      }else{
        final lastAddress=await AddressDbHelper.getLastAddress();
        if(lastAddress!=null){
          longAddress.value=lastAddress.longAddress;
        }
      }

    }
    
  }
}