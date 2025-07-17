import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/product_model.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/profile_controller.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/search_screen/search_screen_controller.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/search_screen/widgets/search_item.dart';

import '../commans/top_bar_cart_btn.dart';
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key, required this.subController});
  final ProfileController subController;

  @override
  Widget build(BuildContext context) {
    final controller=Get.put(SearchScreenController());
    final isDark=isDarkMode(context);

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Search",endWidget: TopBarCartButton(),),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12), // uniform horizontal padding
                decoration: BoxDecoration(
                  color: isDark?Color(0xFF303030):Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Obx(() => TextField(
                  controller: controller.queryController,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins",
                    color: isDark ? Colors.white : Color(0xFF403F3E),
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF403F3E)),
                    suffixIcon: controller.queryText.value.isEmpty
                        ? null
                        : GestureDetector(
                      onTap: controller.clearQuery,
                      child: Icon(Icons.close, color: Color(0xFF403F3E)),
                    ),
                    hintText: "What will you like to eat?",
                    hintStyle: TextStyle(
                      color: Color(0xFF676767),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                    ),
                    border: InputBorder.none,
                  ),
                )),
              ),
              SizedBox(height: 12,),
              Expanded( // or wrap in SizedBox if not using in Column
                child: Obx(()=>ListView.builder(
                    itemCount: controller.products.length,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    itemBuilder: (context, index) {
                      final product=controller.products[index];
                      return SearchItemView(product: product);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


