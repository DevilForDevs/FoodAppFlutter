import 'dart:convert';

import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/networkings.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_screen/controllers/order_model.dart';
import '../product_model.dart';
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

      // ✅ Step 1: Try loading orders with products from DB
      List<Map<String, dynamic>> ordersWithProducts = await DatabaseHelper.getOrdersWithProduct();

      if (ordersWithProducts.isEmpty) {
        print("fetching from api");
        final ordersFromApi = await getOrders(token);
        if (ordersFromApi is List) {
          for (var order in ordersFromApi) {
            try {
              await DatabaseHelper.insertOrderItem(
                userId: order["user_id"].toString(),
                address: order["address"].toString(),
                itemId: int.tryParse(order["item"].toString()) ?? 0,
                phone: order["phone"].toString(),
                quantity: int.tryParse(order["quantity"].toString()) ?? 1,
                price: double.tryParse(order["price"].toString())?.toInt() ?? 0,
                method: order["method"] ?? '',
                status: order["status"] ?? 'pending',
                createdAt: order["created_at"].toString(),
              );
              print("Order inserted successfully.");
            } catch (e) {
              print("❌ Failed to insert order: $e");
            }

          }
          ordersWithProducts = await DatabaseHelper.getOrdersWithProduct();
        } else {
          print("data type mismatch");

        }
      } else {
        print("Loaded orders from local DB.");
      }

      // ✅ Step 2: Display orders with product info
      for (var order in ordersWithProducts) {
        print("Order ID: ${order['id']}");
        print("User ID: ${order['user_id']}");
        print("Product Name: ${order['name']}");
        print("Thumbnail: ${order['thumbnail']}");
        print("Unit: ${order['unit']}");
        print("Quantity: ${order['quantity']}");
        print("-----");
      }
    } else {
      print("No credentials found.");
    }
  }

}


/*await DatabaseHelper.insertOrderItem(
                userId: order['user_id'].toString(),
                address: order['address'].toString(),
                itemId: int.tryParse(order['item'].toString()) ?? 0,
                phone: order['phone'].toString(),
                quantity: int.tryParse(order['quantity'].toString()) ?? 1,
                price: int.tryParse(order['price'].toString()) ?? 0,
                method: order['method'] ?? '',
                status: order['status'] ?? 'pending',
                createdAt: order['created_at'] ?? '',
              );*/
/* {order_id: 4, user_id: 7, address: 1, item: 1, phone: 7632975366, quantity: 1, price: 15.00, method: cod, status: confirmed, created_at: 2025-07-11 10:22:54, updated_at: 2025-07-11 10:22:54}*/