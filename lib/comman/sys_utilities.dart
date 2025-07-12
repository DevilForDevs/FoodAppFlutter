import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}
Future<void> addToCart({
  required int productId,
  required double price,
  required int quantity,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final String? cartJson = prefs.getString("cart");

  // Decode existing cart or initialize empty list
  List<dynamic> cartList = [];
  if (cartJson != null) {
    cartList = jsonDecode(cartJson);
  }

  // Check if item already exists by ID
  final existingIndex = cartList.indexWhere((item) => item['id'] == productId);

  if (existingIndex != -1) {
    // Item exists: update its quantity
    cartList[existingIndex]['qty'] += quantity;
  } else {
    // Item not in cart: add new
    cartList.add({
      "id": productId,
      "price": price,
      "qty": quantity,
    });
  }

  // Save back to SharedPreferences
  await prefs.setString("cart", jsonEncode(cartList));

  print("Updated Cart: $cartList");
}