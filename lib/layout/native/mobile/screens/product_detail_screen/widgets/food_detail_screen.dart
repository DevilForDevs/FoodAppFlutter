import 'package:flutter/material.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_button.dart';
class FoodDetailScreen extends StatelessWidget {
  const FoodDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark=isDarkMode(context);
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
                        image: AssetImage('assets/product_detail.png'), // 🔁 Replace with your image path
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
              SizedBox(height: 16,),
              Text(
                "Chicken & Chips",
                style: TextStyle(
                  color: isDark?Colors.white:Color(0xFF181C2E),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                    fontFamily: "Poppins"
                ),
              ),
              SizedBox(height: 16,),
              Text(
                "Prosciutto e funghi is a pizza variety that it topped with tomato sauce.",
                style: TextStyle(
                  fontSize: 14,
                    fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFA0A5BA)
                ),
              ),
              SizedBox(height: 16,),
              Row(
                children: [
                  Text(
                    "\$32/packet",
                    style: TextStyle(
                      color: isDark?Colors.white:Color(0xFF181C2E),
                      fontSize: 18,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400
                    ),
                  ),

                  Spacer(),
                  Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFF303030), // Change to your desired color
                      borderRadius: BorderRadius.circular(20), // Half of height for capsule effect
                    ),
                    child: Row(
                      children: [
                        // Minus capsule
                        Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(Icons.remove, color: Colors.white),
                        ),
                        SizedBox(width: 12), // spacing between widgets
                        // Center number
                        Text(
                          "2",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            fontFamily: "Poppins",
                          ),
                        ),
                        SizedBox(width: 12),
                        // Plus capsule
                        Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(Icons.add, color: Colors.white),
                        ),
                      ],
                    ),

                  )

                ],
              ),
              SizedBox(height: 16,),
              Center(child: CustomActionButton(label: "Add to cart", onPressed: (){},backgroundColor: Color(0xFFFF7622),)),
              SizedBox(height: 16,),
              Center(child: CustomActionButton(label: "Order Now", onPressed: (){},backgroundColor: Color(0xFFFF7622),)),

            ],
          ),
        ),

      ),
    );
  }
}
