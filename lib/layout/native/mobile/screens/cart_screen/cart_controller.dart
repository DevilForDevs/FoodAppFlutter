import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/networkings.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/cart_button_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../commans/database.dart';
import 'cart_model.dart';

class CartController extends GetxController {
  final cart = <CartItemModel>[].obs;
  final totalPrice = 0.0.obs;
  final contact=TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    final cartItems = await CartDatabase.getCartItems();
    print(cartItems);

    cart.assignAll(cartItems.map((item) => CartItemModel(
      id: item["id"],
      name: item["name"],
      price: item["price"].toDouble(),
      image: item["image"],
      qty: item["qty"],
    )).toList());


    calculateTotalPrice();
    updateCartButtonCount();
  }

  void calculateTotalPrice() {
    double total = 0;
    for (var item in cart) {
      total += item.price.value * item.qty.value;
    }
    totalPrice.value = total;
  }

  Future<void> removeFromCart(CartItemModel itemToRemove) async {
    print("removing");
    final db = await CartDatabase.database;
    await db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [itemToRemove.id.value],
    );

    cart.removeWhere((item) => item.id.value == itemToRemove.id.value);
    calculateTotalPrice();
    updateCartButtonCount();
  }

  Future<void> updateCartButtonCount() async {
    final cartItems = await CartDatabase.getCartItems();
    final cartButtonController = Get.find<CartButtonController>();
    cartButtonController.cartSize.value = cartItems.length;
  }

  Future<bool> placeOrder({required int address_id,required String phone,required String method}) async {
    final prefs = await SharedPreferences.getInstance();
    final credentials = prefs.getString('credentials');

    if (credentials != null) {
      final decodedJson = jsonDecode(credentials);
      final userId=decodedJson["user"]["id"].toString();
      final token = decodedJson["token"];
      for(var item in cart){
        final mResponse=await addOrder(token, userId, address_id.toString(), item.id.value.toString(), phone, item.qty.value, item.price.value.toInt(),method);
      }
      return true;

    }
    return false;

  }
}

