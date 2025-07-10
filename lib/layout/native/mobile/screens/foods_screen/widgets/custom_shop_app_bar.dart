import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/profile_controller.dart';

import '../../commans/top_bar_cart_btn.dart';

class CustomShopAppBarAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomShopAppBarAppBar({super.key, required this.controller});

  @override
  Size get preferredSize => Size.fromHeight(70);
  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    final isDark=isDarkMode(context);
    return SafeArea(
      child: Container(
        height: preferredSize.height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Leading Icon: Circle with 3 bars
            Builder(
              builder:(context)=> GestureDetector(
                onTap: (){
                  Scaffold.of(context).openDrawer();
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark?Color(0xFF676767):Colors.grey.shade200,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 2, width: 8, color:isDark?Colors.white: Colors.black),
                        SizedBox(height: 3),
                        Container(height: 2, width: 16, color: isDark?Colors.white: Colors.black),
                        SizedBox(height: 3),
                        Container(height: 2, width: 12, color: isDark?Colors.white: Colors.black),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 24,),

            // Center Column: Title/Subtitles (customizable)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("DELIVER TO", style: TextStyle(fontSize: 12,fontFamily: "Poppins", fontWeight: FontWeight.w800,color: Color(0xFFFC6E2A))),
                SizedBox(
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center, // align text & icon
                    children: [
                      Obx(()=>Text(
                          controller.addresModel.street.value,
                          style: TextStyle(fontSize: 14, color:isDark?Colors.white: Color(0xFF676767)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle tap
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4), // optional spacing
                          child: Icon(
                            Icons.arrow_drop_down,
                            size: 18, // adjust size to better match text
                            color:Color(0xFF181C2E),
                          ),
                        ),
                      ),
                    ],
                  ),
                )

              ],
            ),
            Spacer(),

            // Cart Icon with Item Count using Stack
            TopBarCartButton(),
          ],
        ),
      ),
    );
  }
}

