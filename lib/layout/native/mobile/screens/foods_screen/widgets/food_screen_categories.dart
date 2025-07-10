import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controllers/food_screen_controller.dart';
class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.controller,
    required this.isDark,
  });

  final FoodScreenController controller;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              controller.categorySelectItem.value = index; // ✅ Fixed assignment
            },
            child: Obx(() {
              bool isSelected = index == controller.categorySelectItem.value;
              return Container(
                margin: index != 0 ? EdgeInsets.only(left: 10) : EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFFFFCA28) :isDark?Color(0xFF303030): Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 5),
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Color(0xFFF0ECE9),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.asset(
                          'assets/pizza.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Burger",
                      style: TextStyle(
                        color: isSelected?Color(0xFF32343E):isDark?Colors.white:Color(0xFF32343E),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}