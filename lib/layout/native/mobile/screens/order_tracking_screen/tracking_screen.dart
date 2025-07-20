import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/chat_screen/chat_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/home_screen/controllers/order_model.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/order_tracking_screen/widgets/stepper.dart';
import 'package:url_launcher/url_launcher.dart';
class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key, required this.order});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final dark=isDarkMode(context);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Track Order"),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image:  DecorationImage(
                        image: NetworkImage(order.image_url),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5,),
                      Text(
                        order.name,
                        style: TextStyle(
                          color:dark?Colors.white: Color(0xFF1A1817),
                          fontFamily: "Sen",
                          fontWeight: FontWeight.w400,
                          fontSize: 18
                        ),
                      ),

                      SizedBox(height: 5,),
                      Text(
                        "Ordered At ${order.createdAt}",
                        style: TextStyle(
                          color: dark?Colors.white:Color(0xFFBFBCBA),
                          fontSize: 14,
                          fontFamily: "Sen",
                          fontWeight: FontWeight.w400
                        ),
                      ),
                      Text(
                        "Quantity ${order.quantity} ${order.unit}"
                      )
                    ],
                  )
                ],
              ),
              SizedBox(height: 20,),
              GestureDetector(
                child: Text(
                  "20 min",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontFamily: "Sen",
                    fontSize: 30
                  ),
                ),
              ),
              Text(
                "Estimated delivery time",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Sen",
                  color: Color(0xFFBFBCBA)
                ),
              ),
              SizedBox(height: 20,),
              Column(
                children:[
                  VerticalStepperItem(
                    title: 'Your order has been received',
                    icon: Icons.check,
                    isFirst: true,
                    isCompleted: true,
                  ),
                  VerticalStepperItem(
                    title: 'Your order has been picked up for delivery',
                    icon: Icons.check,
                    isFirst: false,
                    isCompleted:order.status=="picked" ?true:false,
                  ),
                  VerticalStepperItem(
                    title: 'Item Delivered',
                    icon: Icons.check,
                    isLast: true,
                    isCompleted:order.status=="delivered" ?true:false,
                  ),
                ],
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundImage:AssetImage('assets/me.jpg') as ImageProvider,
                  ),
                  SizedBox(width: 5,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ranjan Kr",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Sen",
                          color:dark?Colors.white: Color(0xFF1A1817),
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      Text(
                          "Manager",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: "Sen",
                          fontSize: 14,
                          color: Color(0xFFBFBCBA)

                        ),
                      ),

                    ],
                  ),
                  SizedBox(width: 24,),
                  GestureDetector(
                    onTap: () async {
                      final Uri uri = Uri(scheme: 'tel', path: "7632975366");
                      if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                      } else {
                        Fluttertoast.showToast(
                          msg: "Failed to launch dial pad",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          fontSize: 16.0,
                        );
                      }
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration:  BoxDecoration(
                        color: Color(0xFFFF7622),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(Icons.call,color: Colors.white,size: 36,),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  GestureDetector(
                    onTap: ()=>Get.to(ChatScreen()),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration:  BoxDecoration(
                        shape: BoxShape.circle,
                          border: Border.all(
                            color: dark?Colors.white:Color(0xFFFF7622), // same as icon color
                            width: 2, // border thickness
                          )
                      ),
                      child: Center(
                        child: Icon(Icons.message,color:dark?Colors.white:Color(0xFFFF7622),size: 36,),
                      ),
                    ),
                  )
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
