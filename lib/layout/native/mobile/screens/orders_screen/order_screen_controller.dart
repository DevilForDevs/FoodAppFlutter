import 'dart:convert';

import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/networkings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../credentials_controller.dart';
import '../home_screen/controllers/order_model.dart';
class OrderScreenController extends GetxController {

  var orders = <OrderModel>[].obs; // observable list of orders
  late CredentialController credentialController;

  @override
  void onInit() {
    super.onInit();
    credentialController=Get.find<CredentialController>();
    setOrders();

  }

  Future<void> setOrders() async {
    final ordersFromApi = await getOrders(credentialController.token.value);
    final itoken=await credentialController.getFirebaseInstallationId();
    if (ordersFromApi is List) {
      for (var order in ordersFromApi) {
        if(credentialController.isQrSignIN.value){
          if(itoken==order["phone"]){
            final timestamp = order["created_at"].toString(); // e.g., "2025-07-21 10:08:36"

// Append 'Z' to mark it as UTC (Z = Zulu time = UTC)
            final timestampWithZ = "${timestamp}Z"; // Now becomes "2025-07-21 10:08:36Z"

// Parse as UTC
            DateTime utcTime = DateTime.parse(timestampWithZ);

// Convert to local time (e.g., Asia/Kolkata if device is in India)
            DateTime localTime = utcTime.toLocal();

// Format as "21 Jul, 15:38"
            String formatted = DateFormat("dd MMM, hh:mm a").format(localTime);
            print("Local time: $formatted");

            orders.add(OrderModel(userId: order["user_id"].toString(), address: order["address"].toString(), item: order['item'].toString(), contact: order['phone'], quantity:order['quantity'], price: double.tryParse(order["price"].toString())?.toInt()??0, method: order['method'], status: order['status'], image_url: order['image_url'], name: order["name"],orderId: order["order_id"],unit: order["unit"],createdAt: formatted));
          }
        }else{
          final timestamp = order["created_at"].toString();
          DateTime utcTime = DateTime.parse(timestamp).toUtc();
          DateTime localTime = utcTime.toLocal();
          String formatted = DateFormat("dd MMM, HH:mm").format(localTime);
          orders.add(OrderModel(userId: order["user_id"].toString(), address: order["address"].toString(), item: order['item'].toString(), contact: order['phone'], quantity:order['quantity'], price: double.tryParse(order["price"].toString())?.toInt()??0, method: order['method'], status: order['status'], image_url: order['image_url'], name: order["name"],orderId: order["order_id"],unit: order["unit"],createdAt: formatted));
        }

      }
    } else {
      print("data type mismatch");

    }



  }


}


