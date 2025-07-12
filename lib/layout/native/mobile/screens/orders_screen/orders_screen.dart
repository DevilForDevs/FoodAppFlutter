import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/orders_screen/order_screen_controller.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark=isDarkMode(context);
    final controller=Get.put(OrderScreenController());
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: "My Orders",
              ),
              const TabBar(
                labelColor: Color(0xFFFF7622),
                unselectedLabelColor: Colors.grey,
                indicatorColor: Color(0xFFFF7622),
                indicatorWeight: 3,
                labelStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(text: "Ongoing"),
                  Tab(text: "History"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ListView.builder(
                      itemCount:controller.orders.length,
                        itemBuilder: (context,index){
                          final orderItem=controller.orders[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if(index==0)SizedBox(height: 12,),
                                Text(
                                  "Food",
                                  style:TextStyle(
                                    fontFamily: "Sen",
                                    fontSize: 14,
                                    fontWeight:FontWeight.w400,
                                    color: isDark?Colors.white:Color(0xFF181C2E)
                                  ) ,
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  height: 1,
                                  color: Color(0xFFEEF2F6),
                                ),
                                SizedBox(height: 13,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: const DecorationImage(
                                          image: AssetImage('assets/orderedfoof.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 5,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Pizza Hut",
                                                style: TextStyle(
                                                  fontFamily: "Sen",
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  color:isDark?Colors.white: Color(0xFF181C2E),
                                                ),
                                              ),
                                              Text(
                                                "#162432",
                                                style: TextStyle(
                                                  fontFamily: "Sen",
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  color: Color(0xFF6B6E82),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8,),
                                          Row(
                                            children: [
                                              Text(
                                                "\$35.25",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "Sen",
                                                  color: isDark?Colors.white:Color(0xFF181C2E),
                                                ),
                                              ),
                                              // Horizontal spacing
                                              const SizedBox(width: 10),
                                              // Vertical line
                                              Container(
                                                width: 1.5, // Slightly thicker
                                                height: 16, // Taller for better visibility
                                                color: Color(0xFFCBD2DC), //
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                "01 Item",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Sen",
                                                  color: Color(0xFF6B6E82),
                                                ),
                                              ),
                                            ],
                                          ),


                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12,),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      height: 35, // Adjust height as per your design
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Your action here
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFFFF7622), // FF7622
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8), // Rounded corners
                                          ),
                                          elevation: 0,
                                        ),
                                        child: const Text(
                                          "Track Order", // Change text as needed
                                          style: TextStyle(
                                            fontFamily: "Sen",
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    SizedBox(
                                      width: 120,
                                      height: 35,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Your action here
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent, // Make background transparent
                                          foregroundColor: Color(0xFFFF7622),  // Text and ripple color
                                          elevation: 0,
                                          side: BorderSide(color: Color(0xFFFF7622)), // Border color
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                            fontFamily: "Sen",
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12,
                                            // No need to set color here as it's handled by `foregroundColor`
                                          ),
                                        ),
                                      ),
                                    )


                                  ],
                                ),
                                SizedBox(height: 12,),
                              ],
                            ),
                          );
                        }
                    ),
                    //history tab
                    ListView.builder(
                        itemCount:8,
                        itemBuilder: (context,index){
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if(index==0)SizedBox(height: 12,),
                                Row(
                                  children: [
                                    Text(
                                      "Food",
                                      style:TextStyle(
                                          fontFamily: "Sen",
                                          fontSize: 14,
                                          fontWeight:FontWeight.w400,
                                          color: isDark?Colors.white:Color(0xFF181C2E)
                                      ) ,
                                    ),
                                    SizedBox(width: 12,),
                                    Text(
                                      "Completed",
                                      style:TextStyle(
                                          fontFamily: "Sen",
                                          fontSize: 14,
                                          fontWeight:FontWeight.w400,
                                          color: Color(0xFF059C6A)
                                      ) ,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  height: 1,
                                  color: Color(0xFFEEF2F6),
                                ),
                                SizedBox(height: 13,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: const DecorationImage(
                                          image: AssetImage('assets/orderedfoof.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 5,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Pizza Hut",
                                                style: TextStyle(
                                                  fontFamily: "Sen",
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  color:isDark?Colors.white: Color(0xFF181C2E),
                                                ),
                                              ),
                                              Text(
                                                "#162432",
                                                style: TextStyle(
                                                  fontFamily: "Sen",
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  color: Color(0xFF6B6E82),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8,),
                                          Row(
                                            children: [
                                              Text(
                                                "\$35.25",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "Sen",
                                                  color: isDark?Colors.white:Color(0xFF181C2E),
                                                ),
                                              ),
                                              // Horizontal spacing
                                              const SizedBox(width: 10),
                                              // Vertical line
                                              Container(
                                                width: 1.5, // Slightly thicker
                                                height: 16, // Taller for better visibility
                                                color: Color(0xFFCBD2DC), //
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                "29 Jan, 12:30",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Sen",
                                                  color: Color(0xFF6B6E82),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 3,left: 7,right: 7),
                                                width: 3, // Diameter
                                                height: 3,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF6B6E82), // Dot color
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Text(
                                                "01 Items",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Sen",
                                                  color: Color(0xFF6B6E82),
                                                ),
                                              ),
                                            ],
                                          ),


                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12,),
                                Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      height: 35, // Adjust height as per your design
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Your action here
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFFFF7622), // FF7622
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8), // Rounded corners
                                          ),
                                          elevation: 0,
                                        ),
                                        child: const Text(
                                          "Re-Order", // Change text as needed
                                          style: TextStyle(
                                            fontFamily: "Sen",
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    SizedBox(
                                      width: 120,
                                      height: 35,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Your action here
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent, // Make background transparent
                                          foregroundColor: Color(0xFFFF7622),  // Text and ripple color
                                          elevation: 0,
                                          side: BorderSide(color: Color(0xFFFF7622)), // Border color
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          "Rate",
                                          style: TextStyle(
                                            fontFamily: "Sen",
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12,
                                            // No need to set color here as it's handled by `foregroundColor`
                                          ),
                                        ),
                                      ),
                                    )


                                  ],
                                ),
                                SizedBox(height: 12,),
                              ],
                            ),
                          );
                        }
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
