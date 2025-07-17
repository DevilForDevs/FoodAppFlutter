import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/product_detail_screen/widgets/food_detail_screen.dart';

import '../../product_model.dart';
class SearchItemView extends StatelessWidget {
  const SearchItemView({
    super.key,

    required this.product,
  });


  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final isDark=isDarkMode(context);
    return GestureDetector(
      onTap: ()=>{
        Get.to(FoodDetailScreen(food: product))
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Card(
          color:isDark?Color(0xFF303030):Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  product.thumbnail,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 8),
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w800,
                    color:isDark?Colors.white:Color(0xFF32343E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.about,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF646982),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "₹${product.price}/${product.unit}",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w800,
                        color: isDark?Colors.white:Color(0xFF32343E),
                      ),
                    ),


                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}