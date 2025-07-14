
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/database.dart';


class CartButtonController extends GetxController {
  final cartSize = 0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    final cartItems = await CartDatabase.getCartItems();
    cartSize.value = cartItems.length;
  }

  @override
  void onClose() {
    cartSize.value = 0;
    super.onClose();
  }
}
