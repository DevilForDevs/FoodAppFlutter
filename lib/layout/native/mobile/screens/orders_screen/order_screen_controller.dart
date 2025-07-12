import 'dart:convert';

import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/networkings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../home_screen/controllers/order_model.dart';
class OrderScreenController extends GetxController {
  var token = "";
  var orders = <OrderModel>[].obs; // observable list of orders

  @override
  void onInit() {
    super.onInit();
    setOrders();
  }

  Future<void> setOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final credentials = prefs.getString('credentials');

    if (credentials != null) {
      final decodedJson = jsonDecode(credentials);
      token = decodedJson["token"];

      final ordersFromApi = await getOrders(token);
      if (ordersFromApi is List) {
        for (var order in ordersFromApi) {
          final timestamp=order["created_at"].toString();
          DateTime dt = DateTime.parse(timestamp);
          String formatted = DateFormat("dd MMM, HH:mm").format(dt);
          print(formatted);
          orders.add(OrderModel(userId: order["user_id"].toString(), address: order["address"].toString(), item: order['item'].toString(), contact: order['phone'], quantity:order['quantity'], price: double.tryParse(order["price"].toString())?.toInt()??0, method: order['method'], status: order['status'], image_url: order['image_url'], name: order["name"],orderId: order["order_id"],unit: order["unit"],createdAt: formatted));
        }
      } else {
        print("data type mismatch");

      }
    } else {
      print("No credentials found.");
    }
  }

}


