import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/primary_item_card.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';

import '../product_detail_screen/widgets/food_detail_screen.dart';
class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark=isDarkMode(context);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Wishlist"),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            padding: EdgeInsets.all(0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 200, // forces item height
            ),
            itemCount: 10,
            itemBuilder: (context, index) {
              // return PrimaryItemCard(isDark: isDark,sideIcon: Icons.favorite,);
            },
          ),
        ),

      ),
    );
  }
}
