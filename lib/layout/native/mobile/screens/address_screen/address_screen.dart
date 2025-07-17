import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/address_model.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/address_screen/edit_address_controller.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_button.dart';


class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key, required this.addressModel});
  final AddressModel addressModel;
  @override
  Widget build(BuildContext context) {
    final controller=Get.put(EditAddressController(addressModel));
    final isDark=isDarkMode(context);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Edit Address"),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Full ADDRESS",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Poppins",
                  color: isDark?Colors.white:Color(0xFF1A1817),
                ),
              ),
              SizedBox(height: 4),
              TextField(
                controller: controller.longAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark?Color(0xFF303030):Color(0xFFF0F5FA),
                  contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  hintText: 'village, post, city',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "City",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                          color: isDark?Colors.white:Color(0xFF1A1817),
                        ),
                      ),
                      SizedBox(height: 4),
                      SizedBox(
                        width: 135,
                        child: TextField(
                          controller: controller.city,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: isDark?Color(0xFF303030):Color(0xFFF0F5FA),
                            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            hintText: 'Enter nearby city...',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pincode",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                          color: isDark?Colors.white: Color(0xFF1A1817),
                        ),
                      ),
                      SizedBox(height: 4),
                      SizedBox(
                        width: 135,
                        child: TextField(
                          controller: controller.pinCode,
                          keyboardType: TextInputType.number, // Show number keyboard
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          maxLength: 6, // Only allow digits (0-9)
                          decoration: InputDecoration(
                            filled: true,
                            fillColor:isDark?Color(0xFF303030): Color(0xFFF0F5FA),
                            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            hintText: 'Enter pincode',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 16,),
              Text(
                "Village",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Poppins",
                  color:isDark?Colors.white: Color(0xFF1A1817)
                ),
              ),
              TextField(
                controller: controller.village,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark?Color(0xFF303030):Color(0xFFF0F5FA),
                  contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  hintText: 'Enter village,land mark...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16,),
              Text(
                "Address Type",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins",
                    color:isDark?Colors.white: Color(0xFF1A1817)
                ),
              ),
              SizedBox(height: 4,),
              SizedBox(
                height: 35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.addressTypes.length,
                  itemBuilder: (context, index) {
                    return Obx(() {
                      final isSelected = controller.selectedIndex.value == index;

                      return GestureDetector(
                        onTap: () {
                          controller.selectedIndex.value = index;
                        },
                        child: Container(
                          margin: index != 0 ? EdgeInsets.only(left: 10) : EdgeInsets.zero,
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(0xFFFF7622)
                                : isDark
                                ? Color(0xFF303030)
                                : Color(0xFFF0F5FA),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            controller.addressTypes[index],
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? Colors.white : Color(0xFF1A1817)),
                              fontSize: 12,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
              SizedBox(height: 16,),
              CustomActionButton(width:400,backgroundColor:Color(0xFFFF7622),label: "SAVE LOCATION", onPressed: ()=>controller.saveAddress(),textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: "Poppins",
                color: Colors.white
              ),)

            ],
          ),
        ),
      ),
    );
  }
}
