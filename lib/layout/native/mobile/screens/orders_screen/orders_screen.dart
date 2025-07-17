import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/home_screen/controllers/order_model.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/orders_screen/order_screen_controller.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/orders_screen/widgets/on_going_order_item.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/orders_screen/widgets/order_history_item.dart';

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
                    Obx(()=>controller.orders.isEmpty?Center(
                      child: Text("You have not ordered anything"),
                    ):ListView.builder(
                        itemCount:controller.orders.length,
                        itemBuilder: (context,index){
                          final orderItem=controller.orders[index];

                          return OnGoingOrderItem(orderItem: orderItem,index: index,);
                        }
                    ),
                    ),
                    //history tab
                    Obx(()=>controller.orders.isEmpty?Center(
                      child: Text("You have no orders history"),
                    ):ListView.builder(
                        itemCount:controller.orders.length,
                        itemBuilder: (context,index){
                          final orderItem=controller.orders[index];
                          return OrderHistoryItem(orderItem: orderItem,index: index,);
                        }
                    ),
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

