import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:jalebi_shop_flutter/comman/primary_item_card.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/foods_screen/controllers/food_screen_controller.dart';
class AllItem extends StatelessWidget {
  const AllItem({super.key, required this.controller});
  final FoodScreenController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Popular Burgers"),
        body:Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Obx(()=>GridView.builder(
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
              ),
            ],
          ),
        )
      ),
    );
  }
}
