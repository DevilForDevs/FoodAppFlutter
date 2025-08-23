import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/orders_screen/order_screen_controller.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/orders_screen/widgets/on_going_order_item.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/orders_screen/widgets/order_history_item.dart';

import '../credentials_controller.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller=Get.put(OrderScreenController());
    return WillPopScope(
      onWillPop: () async {
        // Close all GetX routes if any
        Get.close(0); // closes all snackbars/dialogs if open

        // Clear GetX navigation stack
        Get.offAll(() => const SizedBox()); // dummy widget to reset

        // Exit the app cleanly
        Future.delayed(Duration(milliseconds: 100), () {
          SystemNavigator.pop();
        });

        return false;
      },
      child: SafeArea(
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
                      Obx(() {
                        final confirmedOrders = controller.orders.where((e) => e.status == "confirmed").toList();
                        return confirmedOrders.isEmpty
                            ? Center(child: Text("No ongoing orders"))
                            : ListView.builder(
                          itemCount: confirmedOrders.length,
                          itemBuilder: (context, index) {
                            final orderItem = confirmedOrders[index];
                            return OnGoingOrderItem(orderItem: orderItem, index: index, ocontoller: controller);
                          },
                        );
                      }),

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
      ),
    );
  }
}

