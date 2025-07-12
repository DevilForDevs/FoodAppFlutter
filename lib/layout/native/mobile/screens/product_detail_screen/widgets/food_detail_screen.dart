

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/cart_screen/cart_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_button.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/place_order_screen/place_order_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/product_detail_screen/detail_screen_controller.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/product_model.dart';


class FoodDetailScreen extends StatelessWidget {
  const FoodDetailScreen({super.key, required this.food});
  final ProductModel food;

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    final controller = Get.put(DetailScreenController());
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Details"),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  // Image with rounded corners
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(
                          food.thumbnail,
                        ), // 🔁 Replace with your image path
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Heart icon at bottom-left
                  /*Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(onPressed: (){}, icon: Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                      )),
                    ),
                  )*/
                ],
              ),
              SizedBox(height: 16),
              Text(
                food.name,
                style: TextStyle(
                  color: isDark ? Colors.white : Color(0xFF181C2E),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  fontFamily: "Poppins",
                ),
              ),
              SizedBox(height: 16),
              Text(
                food.about,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFA0A5BA),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    "₹${food.price}/${food.unit}",
                    style: TextStyle(
                      color: isDark ? Colors.white : Color(0xFF181C2E),
                      fontSize: 18,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  Spacer(),
                  Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFF303030), // Change to your desired color
                      borderRadius: BorderRadius.circular(
                        20,
                      ), // Half of height for capsule effect
                    ),
                    child: Row(
                      children: [
                        // Minus capsule
                        GestureDetector(
                          onTap:
                              () => {
                                if (controller.quantity.value > 1){
                                  controller.quantity.value--
                                }
                              },
                          child: Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Icon(Icons.remove, color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 12), // spacing between widgets
                        // Center number
                        Obx(
                          () => Text(
                            controller.quantity.value.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        // Plus capsule
                        GestureDetector(
                          onTap: () {
                            final price = food.price;
                            final currentQty = controller.quantity.value;

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
                              controller.quantity.value++;
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
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Icon(Icons.add, color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(height: 16),
              Center(
                child: CustomActionButton(
                  label: "Order Now",
                  onPressed:()=>Get.to(PlaceOrderScreen(food: food,quantity: controller.quantity.value,)),
                  backgroundColor: Color(0xFFFF7622),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: CustomActionButton(
                  label: "Add to cart",
                  onPressed: () async {
                    final msg = await addToCart(
                      productId: 1,
                      price: food.price.toDouble(),
                      quantity: controller.quantity.value,
                    );

                    // Show snackbar confirmation
                    Get.snackbar(
                      "Cart",
                      "Item added to cart",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      duration: Duration(seconds: 2),
                    );

                    // Show dialog asking if user wants to go to cart
                    Future.delayed(Duration(milliseconds: 300), () {
                      Get.defaultDialog(
                        title: "Go to Cart?",
                        middleText: "Would you like to view your cart now?",
                        textCancel: "No",
                        textConfirm: "Yes",
                        onConfirm: () {
                          Get.back(); // Close dialog
                          Get.to(CartScreen());
                        },
                        onCancel: () {
                          // just close the dialog
                        },
                      );
                    });
                  }
                  ,
                  backgroundColor: Color(0xFFFF7622),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
