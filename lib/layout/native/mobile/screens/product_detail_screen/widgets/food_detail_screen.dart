

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/banner_ad_widget.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/cart_screen/cart_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_button.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/database.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/credentials_controller.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/place_order_screen/place_order_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/product_detail_screen/detail_screen_controller.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/product_detail_screen/widgets/ad_button.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/product_model.dart';

import '../../ads_controller.dart';


class FoodDetailScreen extends StatelessWidget {
  const FoodDetailScreen({super.key, required this.food});
  final ProductModel food;

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    final controller = Get.put(DetailScreenController());
    final AdController adController = Get.find();
    final credentialController=Get.find<CredentialController>();
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
              SizedBox(height: 46),
              Center(
                child: CustomActionButtonAd(
                  label: "🎁 Watch Ad to Unlock 20% Discount",
                  onPressed: () {
                    Get.find<AdController>().showRewardedAd(
                      onRewarded: () {
                        Get.to(PlaceOrderScreen(food: food,quantity: controller.quantity.value,discontPrice: food.price-3,));
                        /*adController.showInterstitialAd(onAdClosed: (){

                        });*/
                      },
                    );
                  },
                  backgroundColor: Color(0xFFFFC107), // Yellow
                  textColor: Colors.black,
                  borderRadius: 16,
                  elevation: 6,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: CustomActionButton(
                  label: "Order Now",
                  onPressed:(){
                    Get.to(PlaceOrderScreen(food: food,quantity: controller.quantity.value,discontPrice: food.price-0,));
                   /* adController.showInterstitialAd(onAdClosed: (){
                      Get.to(PlaceOrderScreen(food: food,quantity: controller.quantity.value,discontPrice: food.price-0,));
                    });*/
                  },
                  backgroundColor: Color(0xFFFF7622),
                ),
              ),
              SizedBox(height: 40),
              Center(child: BannerAdWidget())

            ],
          ),
        ),
      ),
    );
  }
}
