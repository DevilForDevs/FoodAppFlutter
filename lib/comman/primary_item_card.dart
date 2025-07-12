import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/product_model.dart';


import '../layout/native/mobile/screens/favourite_screen/favourite_screen.dart';
import '../layout/native/mobile/screens/product_detail_screen/widgets/food_detail_screen.dart';
class PrimaryItemCard extends StatelessWidget {
  const PrimaryItemCard({
    super.key,
    this.sideIcon=Icons.favorite_border, required this.productModel,
  });

  final IconData sideIcon;
  final ProductModel productModel;
  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);

    return GestureDetector(
      onTap: () => Get.to(FoodDetailScreen(food: productModel,)),
      child: SizedBox(
        height: 50, // increased height to prevent overflow
        width: 50,
        child: Card(
          color: isDark ? Color(0xFF303030) : Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // auto-fit content vertically
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Make image expandable with fixed aspect ratio
                AspectRatio(
                  aspectRatio: 1.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      productModel.thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.broken_image),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  productModel.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Color(0xFF32343E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  productModel.about,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                      "₹${productModel.price}",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : Color(0xFF32343E),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Get.to(FavouriteScreen()),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          sideIcon,
                          color: Color(0xFFE53935),
                          size: 20,
                        ),
                      ),
                    )
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