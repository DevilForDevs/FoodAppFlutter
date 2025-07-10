import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/address_screen/address_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/addresses_list/address_list_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/cart_screen/cart_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/chat_screen/chat_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/favourite_screen/favourite_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/notifications_screen/notification_scren.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/personal_info_screen/personal_info_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/profile_controller.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/settings_screen/settings_screen.dart';

import '../../../../../comman/profile_list_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark=isDarkMode(context);
    final controller=Get.put(ProfileController());
    return SafeArea(
      child: Scaffold(
        appBar:CustomAppBar(
          title: "My Profile",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          "assets/person.png",
                          fit: BoxFit.cover,
                          width: 180,
                          height: 180,
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.name.value,
                          style: TextStyle(
                            color:isDark?Colors.white: Color(0xFF32343E),
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Sen"
                          ),
                        ),
                        Text(
                          "I love fast food",
                          style: TextStyle(
                              color: Color(0xFFA0A5BA),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Sen"
                          ),
                        ),

                      ],
                    )

                  ],
                ),
                SizedBox(height: 16,),
                Container(
                  decoration: BoxDecoration(
                    color: isDark?Color(0xFF303030):Color(0xFFF0F5FA), // Replace with your desired color
                    borderRadius: BorderRadius.circular(12), // Adjust the radius as needed
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: ProfileListItem(title:"Personal Info",icon: Icons.person,iconColor: Color(0xFFFB6F3D),onTap:()=>Get.to(PersonalInfoScreen()),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: ProfileListItem(title:"Addresses",icon: Icons.location_city,iconColor: Color(0xFF413DFB),onTap: ()=>Get.to(AddressListScreen()),),
                      ), // Your children widgets here
                    ],
                  ),
                ),
                SizedBox(height: 16,),
                Container(
                  decoration: BoxDecoration(
                    color:isDark?Color(0xFF303030): Color(0xFFF0F5FA), // Replace with your desired color
                    borderRadius: BorderRadius.circular(12), // Adjust the radius as needed
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: ProfileListItem(title:"Cart",icon: Icons.shopping_cart,iconColor: Color(0xFF369BFF),onTap: ()=>Get.to(CartScreen()),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: ProfileListItem(title:"Favourite",icon: Icons.favorite_border,iconColor: Color(0xFFB33DFB),onTap: ()=>Get.to(FavouriteScreen()),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: ProfileListItem(title:"Notifications",icon: Icons.notifications,iconColor: Color(0xFFFFAA2A),onTap: ()=>Get.to(NotificationScreen()),),
                      ),



                    ],
                  ),
                ),
                SizedBox(height: 16,),
                Container(
                  decoration: BoxDecoration(
                    color: isDark?Color(0xFF303030):Color(0xFFF0F5FA), // Replace with your desired color
                    borderRadius: BorderRadius.circular(12), // Adjust the radius as needed
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: ProfileListItem(title:"Help",icon: Icons.question_mark,iconColor: Color(0xFFFB6F3D),onTap: ()=>Get.to(ChatScreen()),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: ProfileListItem(title:"Settings",icon: Icons.settings_outlined,iconColor: Color(0xFF413DFB),onTap: ()=>Get.to(SettingsScreen()),),
                      ), // Your children widgets here

                    ],
                  ),
                ),
                SizedBox(height: 16,),
                Container(
                  decoration: BoxDecoration(
                    color: isDark?Color(0xFF303030):Color(0xFFF0F5FA), // Replace with your desired color
                    borderRadius: BorderRadius.circular(12), // Adjust the radius as needed
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: ProfileListItem(title:"Log Out",icon: Icons.logout,iconColor: Color(0xFFFB4A59),onTap: (){},),
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


/*endWidget: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFECF0F4),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.more_horiz_outlined,
                color: Colors.black,
                size: 16,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          )*/

