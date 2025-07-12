import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/all_items_screen/all_item.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/foods_screen/controllers/food_screen_controller.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/foods_screen/widgets/custom_shop_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/search_screen/search_screen.dart';

import '../../../../../comman/food_screen_drawer.dart';
import '../../../../../comman/food_scrren_header.dart';
import '../../../../../comman/primary_item_card.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FoodScreenController());
    final isDark = isDarkMode(context);
    return SafeArea(
      child: Scaffold(
        appBar: CustomShopAppBarAppBar(controller: controller.subController,),
        drawer: FoodScreenDrawer(isDark: isDark,controller: controller.subController,),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FoodScreenHeader(controller: controller.subController,),
              SizedBox(height: 12),
              GestureDetector(
                onTap: () => Get.to(SearchScreen()),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? Color(0xFF303030) : Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: isDark ? Color(0xFF939393) : Color(0xFF403F3E)),
                      SizedBox(width: 10),
                      Text(
                        "What will you like to eat?",
                        style: TextStyle(
                          color: isDark ? Color(0xFF939393) : Color(0xFF676767),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    "Popular street food",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "See All",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white : Color(0xFF333333),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.to(AllItem(controller: controller,)),
                    icon: Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 18,
                      color: isDark ? Colors.white : Color(0xFFA0A5BA),
                    ),
                  )
                ],
              ),
              SizedBox(height: 12),
              Obx(()=>GridView.builder(
                  itemCount:controller.products.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 items per row
                    childAspectRatio: 0.8, // Adjust based on card height/width
                  ),
                  itemBuilder: (context, index) {
                    final product=controller.products[index];
                    return PrimaryItemCard(productModel: product,);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}















/*620519*/

