import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/personal_info_screen/personal_info_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/profile_controller.dart';

import '../layout/native/mobile/screens/address_screen/address_screen.dart';
import '../layout/native/mobile/screens/cart_screen/cart_screen.dart';
import '../layout/native/mobile/screens/orders_screen/orders_screen.dart';
import '../layout/native/mobile/screens/profile_screen/profile_screen.dart';
import 'log_out_dialog.dart';
class FoodScreenDrawer extends StatelessWidget {
  const FoodScreenDrawer({
    super.key,
    required this.isDark, required this.controller,
  });

  final bool isDark;
  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color:isDark?Color(0xFF303030): Color(0xFFFFCA28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                    child: Row(
                      children: [
                        Obx(()=> Text(
                            controller.name.value,
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),
                        Spacer(),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon:Icon(Icons.arrow_back_ios_new,size: 18,color: Colors.white))
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Obx(
                              () => CircleAvatar(
                            radius: 40,
                            backgroundImage: controller.pickedImage.value != null
                                ? FileImage(controller.pickedImage.value!) // Use the picked image if available
                                : AssetImage('assets/person.png') as ImageProvider, // Use the default image if not
                          ),
                        ),
                      ),
                      Spacer(),
                      IconButton(onPressed: ()=>Get.to(PersonalInfoScreen()), icon:Icon(Icons.edit,size: 18,color: Colors.white))

                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(()=>Text(
                            controller.addresModel.longAddress.value,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,


                          ),
                        ),
                      ),
                      IconButton(onPressed: ()=>Get.to(AddressScreen(addressModel: controller.addresModel,)), icon:Icon(Icons.edit,size: 18,color: Colors.white))
                    ],
                  ),

                ],

              )
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Profile'),
                Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
            onTap: ()=>Get.to(ProfileScreen()),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Cart'),
                Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
            onTap: ()=>Get.to(CartScreen()),
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag_outlined),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Orders'),
                Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
            onTap: ()=>Get.to(OrdersScreen()),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Log out'),
                Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
            onTap:() => showLogoutDialog(context),
          ),

        ],
      ),
    );
  }
}