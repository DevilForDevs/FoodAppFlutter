import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../product_model.dart';

class SearchScreenController extends GetxController {
  final queryController = TextEditingController();
  final queryText = ''.obs;
  final products=<ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    queryController.addListener(() {
      queryText.value = queryController.text;
    });
  }

  void clearQuery() {
    queryController.clear();
    queryText.value = '';
  }
}
