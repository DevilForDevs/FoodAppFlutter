import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/cart_screen/cart_controller.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/check_out_screen/check_out_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_button.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/credentials_controller.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/select_address/select_address.dart';

import '../sucess_screen/sucess_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark=isDarkMode(context);
    final controller=Get.put(CartController());
    final credentialController=Get.find<CredentialController>();

    return SafeArea(
      child:Scaffold(
        appBar: CustomAppBar(title: "Cart"),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(16),
          height: 200,
          decoration: BoxDecoration(
            color: isDark?Color(0xFF303030):Color(0xFFF0F5FA),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                      "Delivery Address",
                    style: TextStyle(
                      color: Color(0xFFA0A5BA),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins"
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: ()=>Get.to(SelectAddressScreen()),
                    child: Text(
                      "CHANGE",
                      style: TextStyle(
                          color: Color(0xFFFF7622),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins"
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 12,),
              Obx(()=> Text(credentialController.addresses.isEmpty?"NO Address Found":credentialController.addresses[credentialController.selectedAddressIndex.value].longAddress),),
              SizedBox(height: 12,),
              Row(
                children: [
                  Text(
                    "Total:",
                    style: TextStyle(
                        color: Color(0xFFA0A5BA),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins"
                    ),
                  ),
                  Spacer(),
                  Obx(()=>Text(
                      "₹${controller.totalPrice.value.toInt()}",
                      style: TextStyle(
                          color:isDark?Colors.white: Color(0xFF181C2E),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins"
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5,),
              Center(
                child: CustomActionButton(
                  label: "Place Order",
                  backgroundColor: Color(0xFFFF7622),
                  onPressed: () async {


                    final result = await Get.dialog<String>(
                      AlertDialog(
                        title: Text("Enter your phone number"),
                        content: TextField(
                          controller: controller.contact,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(hintText: "Phone Number"),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(), // Cancel
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              final phone = controller.contact.text.trim();
                              if (phone.isNotEmpty) {
                                Get.back(result: phone); // Return phone number
                              }
                            },
                            child: Text("Continue"),
                          ),
                        ],
                      ),
                    );

                    if (result != null && result.isNotEmpty) {
                      // You now have the phone number in `result`
                      Get.to(
                        CheckOutScreen(
                          totalPrice: controller.totalPrice.value.toInt(),
                          payFailure: () {
                            Fluttertoast.showToast(
                              msg: "Payment Failed",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              fontSize: 16.0,
                            );
                          },
                          paySuccess: (tid) async {
                            final orderPlaced = await controller.placeOrder(phone: result,method: tid
                            );
                            if(orderPlaced){
                              if(orderPlaced){
                                for(var m in controller.cart){
                                  controller.removeFromCart(m);
                                }
                                Get.off(SucessScreen());
                              }
                            }else{
                              Fluttertoast.showToast(
                                msg: "Failed to place order",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                fontSize: 16.0,
                              );
                            }


                          },
                        ),
                      );
                    }
                  },
                ),
              )

            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(12),
          child:Obx(()=>controller.cart.isEmpty?
          Center(
            child: Text(
              "Cart is Empty"
            ),
          ):ListView.builder(

            itemCount: controller.cart.length,
            itemBuilder: (context,index){
              final cartItem=controller.cart[index];
              return Padding(
                padding: EdgeInsets.zero,
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                        image: DecorationImage(
                          image: NetworkImage(cartItem.image.value), // Replace with your asset path
                          fit: BoxFit.cover, // or BoxFit.contain, based on need
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            children: [
                              Text(
                                cartItem.name.value,
                                style: TextStyle(
                                    color:isDark?Colors.white: Color(0xFF1A1817),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Poppins"
                                ),
                              ),
                              SizedBox(width: 16,),
                              GestureDetector(
                                onTap: ()=>controller.removeFromCart(cartItem),
                                child: Container(
                                  height: 24,
                                  width: 24,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE04444),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Icon(Icons.close, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 12,),
                        Row(
                          children: [
                            Text(
                              "₹${cartItem.price.value.toInt()}",
                              style: TextStyle(
                                  color: isDark?Colors.white:Color(0xFf1A1817),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: "Poppins"
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 12,),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                if(cartItem.qty.value<1){
                                  cartItem.qty.value--;
                                  controller.totalPrice.value=controller.totalPrice.value-cartItem.price.value;
                                }

                              },
                              child: Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Icon(Icons.remove, color: isDark?Colors.white:Colors.black),
                              ),
                            ),
                            SizedBox(width: 12,),
                            Obx(()=>Text(
                              "${cartItem.qty.value}",
                              style: TextStyle(
                                  color: isDark?Colors.white:Color(0xFf1A1817),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: "Poppins"
                              ),
                            ),
                            ),
                            SizedBox(width: 12,),
                            GestureDetector(
                              onTap: (){
                                final price = cartItem.price;
                                final currentQty = cartItem.qty.value;

                                // Determine the max quantity based on the price
                                int maxQty;
                                if (price <= 2) {
                                  maxQty = 4;
                                } else if (price >= 3 && price <= 5) {
                                  maxQty = 2;
                                } else {
                                  maxQty = 1;
                                }

                                // Only increment if current quantity is less than max allowed
                                if (currentQty < maxQty) {
                                  cartItem.qty.value++;
                                  controller.totalPrice.value=controller.totalPrice.value+cartItem.price.value;
                                }else{
                                  Get.snackbar("Max Orderable","Quantity is ${maxQty.toString()}",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                              child: Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Icon(Icons.add, color: isDark?Colors.white:Colors.black),
                              ),
                            ),

                          ],
                        )
                      ],
                    ),


                  ],
                ) ,
              );
            },
          ),
          ),
        ),
      ) ,
    );
  }
}
