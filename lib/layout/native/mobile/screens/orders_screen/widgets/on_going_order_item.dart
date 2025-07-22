import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jalebi_shop_flutter/comman/log_out_dialog.dart';
import 'package:jalebi_shop_flutter/comman/networkings.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/credentials_controller.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/order_tracking_screen/tracking_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/orders_screen/order_screen_controller.dart';
import '../../home_screen/controllers/order_model.dart';
class OnGoingOrderItem extends StatelessWidget {
  const OnGoingOrderItem({
    super.key,
    required this.orderItem, required this.index, required this.ocontoller,
  });


  final OrderModel orderItem;
  final int index;
  final OrderScreenController ocontoller;


  @override
  Widget build(BuildContext context) {
    final controller=Get.find<CredentialController>();
    final isDark=isDarkMode(context);
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
                  image:  DecorationImage(
                    image: NetworkImage(orderItem.image_url),
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
                          orderItem.name,
                          style: TextStyle(
                            fontFamily: "Sen",
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color:isDark?Colors.white: Color(0xFF181C2E),
                          ),
                        ),
                        Text(
                          "#${orderItem.orderId}",
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
                          "₹${orderItem.price*orderItem.quantity}",
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
                          "${orderItem.quantity} Item",
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
                  onPressed: ()=>Get.to(TrackingScreen(order: orderItem,)),
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
                  onPressed: () async {
                    if(controller.isQrSignIN.value){
                      Fluttertoast.showToast(
                        msg: "You can't cancel order",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        fontSize: 16.0,
                      );
                    }else{
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Confirm Cancellation"),
                          content: Text("Are you sure you want to cancel this order_tracking_screen?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text("No"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text("Yes"),
                            ),
                          ],
                        ),
                      );


                      if (confirm == true) {
                        showLoadingDialog(context);
                        final response = await cancelOrder(controller.token.value, orderItem.orderId);
                        if (response.contains("successfully")) {
                          Get.back();
                          Fluttertoast.showToast(
                            msg: "Order Canceled Successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            fontSize: 16.0,
                          );
                          ocontoller.orders[index]=OrderModel(userId: orderItem.userId, address: orderItem.address, item:orderItem.item, contact: orderItem.contact, quantity: orderItem.quantity, price: orderItem.price, method:orderItem.method, status: "cancelled", image_url: orderItem.image_url, name: orderItem.name, orderId: orderItem.orderId, unit: orderItem.unit);
                        } else {
                          Get.back();
                          print(response);
                          Fluttertoast.showToast(
                            msg: response,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            fontSize: 16.0,
                          );
                        }
                      }
                    }
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
}