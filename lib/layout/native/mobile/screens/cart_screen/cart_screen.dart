import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/cart_screen/cart_controller.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_button.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/profile_controller.dart';
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark=isDarkMode(context);
    final controller=Get.put(CartController());
    final address=Get.find<ProfileController>();
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
                    onTap: (){},
                    child: Text(
                      "EDIT",
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
              Obx(()=>Text(
                   address.addresModel.longAddress.value,
                    style: TextStyle(
                        color: Color(0xFFA0A5BA),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins"
                    ),
                  ),
              ),
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
                  Text(
                    "₹${controller.totalPrice.toInt()}",
                    style: TextStyle(
                        color:isDark?Colors.white: Color(0xFF181C2E),
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins"
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5,),
              Center(child: CustomActionButton(label: "Place Order", onPressed: (){},backgroundColor:Color(0xFFFF7622) ,))
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(12),
          child: Obx(()=>ListView.builder(
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
                          Row(
                            children: [
                              Text(
                                "₹${cartItem.price.toInt()}",
                                style: TextStyle(
                                  color: isDark?Colors.white:Color(0xFf1A1817),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: "Poppins"
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: (){

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
