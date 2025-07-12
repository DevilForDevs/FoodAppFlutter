import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/cart_button_controller.dart';
import '../commans/database.dart';
import 'cart_model.dart';

class CartController extends GetxController {
  final cart = <CartItemModel>[].obs;
  final totalPrice = 0.0.obs;

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
    final db = await CartDatabase.database;
    await db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [itemToRemove.id],
    );

    cart.removeWhere((item) => item.id == itemToRemove.id);
    calculateTotalPrice();
    updateCartButtonCount();
  }

  Future<void> updateCartButtonCount() async {
    final cartItems = await CartDatabase.getCartItems();
    final cartButtonController = Get.find<CartButtonController>();
    cartButtonController.cartSize.value = cartItems.length;
  }
}

