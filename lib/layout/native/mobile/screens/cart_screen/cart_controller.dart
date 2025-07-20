
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/networkings.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/credentials_controller.dart';
import '../commans/database.dart';
import 'cart_model.dart';

class CartController extends GetxController {
  final cart = <CartItemModel>[].obs;
  final totalPrice = 0.0.obs;
  final contact=TextEditingController();
  late CredentialController credentialController;

  @override
  void onInit() {
    super.onInit();
    credentialController=Get.find<CredentialController>();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    final cartItems = await CartDatabase.getCartItems();
    cart.assignAll(cartItems.map((item) => CartItemModel(
      id: item["id"],
      name: item["name"],
      price: item["price"].toDouble(),
      image: item["image"],
      qty: item["qty"],
    )).toList());


    calculateTotalPrice();

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
    credentialController.cartSize.value=cartItems.length;
  }

  Future<bool> placeOrder({required String phone,required String method}) async {
    final addressId=credentialController.addresses[credentialController.selectedAddressIndex.value].addressId;
    for(var item in cart){
      final mResponse=await addOrder(credentialController.token.value, credentialController.userId, addressId.toString(), item.id.value.toString(), phone, item.qty.value, item.price.value.toInt(),method);
      if(mResponse.contains("error message")){
        return false;
      }

    }
    return true;


  }
}

