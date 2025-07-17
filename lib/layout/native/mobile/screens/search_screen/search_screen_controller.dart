import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/networkings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../product_model.dart';

class SearchScreenController extends GetxController {
  final queryController = TextEditingController();
  final queryText = ''.obs;
  final products = <ProductModel>[].obs;
  var token = "".obs;
  var userId = "".obs;

  var isSearching = false.obs; // <-- control flag

  @override
  Future<void> onInit() async {
    super.onInit();
    final prefs = await SharedPreferences.getInstance();
    final credentials = prefs.getString('credentials');

    if (credentials != null) {
      final decodedJson = jsonDecode(credentials);
      userId.value = decodedJson["user"]["id"].toString();
      token.value = decodedJson["token"];
    }

    queryController.addListener(_onQueryChanged);
  }

  Future<void> _onQueryChanged() async {
    final currentQuery = queryController.text.trim();
    queryText.value = currentQuery;

    if (currentQuery.isEmpty) {
      products.clear(); // 👈 clear product list
      return;
    }

    isSearching.value = true;

    try {
      final response = await searchItems(token.value,currentQuery);
      final items=response as List;
      for (var item in items) {
        final id = item["id"];
        final exists = products.any((product) => product.item_id == id);

        if (!exists) {
          products.add(ProductModel(
            name: item["name"],
            thumbnail: item["image_url"],
            price: item["price"],
            isFavourite: false,
            about: item["description"],
            unit: item["unit"],
            item_id: id,
          ));
        }
      }
    } catch (e) {
      print('Search error: $e');
    } finally {
      isSearching.value = false;
    }
  }

  void clearQuery() {
    queryController.clear();
    queryText.value = '';
  }

  @override
  void onClose() {
    queryController.removeListener(_onQueryChanged);
    queryController.dispose();
    super.onClose();
  }
}

