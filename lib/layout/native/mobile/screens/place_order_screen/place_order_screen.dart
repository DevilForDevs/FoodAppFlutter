import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/check_out_screen/check_out_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_button.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/product_model.dart';

import '../addresses_list/address_screen_controller.dart';
import '../commans/custom_app_bar.dart';
import '../sucess_screen/sucess_screen.dart';

class PlaceOrderScreen extends StatelessWidget {
  const PlaceOrderScreen({super.key, required this.food, required this.quantity});
  final ProductModel food;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    final controller = Get.put(AddressScreenController());

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Order Details"),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          children: [
            // 🔷 Product Image
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(food.thumbnail),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 12),

            // 🔷 Name
            Text(
              food.name,
              style: TextStyle(
                color: isDark ? Colors.white : Color(0xFF181C2E),
                fontSize: 20,
                fontWeight: FontWeight.w800,
                fontFamily: "Poppins",
              ),
            ),
            SizedBox(height: 8),

            // 🔷 About
            Text(
              food.about,
              style: TextStyle(
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
                color: Color(0xFFA0A5BA),
              ),
            ),
            SizedBox(height: 8),

            _rowText("Quantity :", quantity.toString()),
            _rowText("Rate :", "₹${food.price}/${food.unit}"),
            _rowText("Total Price :", "₹${quantity * food.price}"),

            SizedBox(height: 8),
            _rowText("Contact :", ""),
            SizedBox(
              width: double.infinity,
              child: TextField(
                controller: controller.phone,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? Color(0xFF303030) : Color(0xFFF0F5FA),
                  contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  hintText: 'Enter phone no',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),
            Text("Select Address", style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 8),

            Obx(() => ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.addressList.length,
              itemBuilder: (context, index) {
                final address = controller.addressList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  color: isDark ? const Color(0xFF303030) : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                address.addressType.value,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if(controller.selectedAddressIndex.value==index)Container(
                              height: 24,
                              width: 24,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Color(0xFFFF7622),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.check, color: Colors.white),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Color(0xFFFF7622)),
                              onPressed: () => controller.editAddress(index),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                            onTap:(){
                              controller.selectedAddressIndex.value=index;
                            },
                            child: Text(address.longAddress.value)
                        ),
                      ],
                    ),
                  ),
                );
              },
            )),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24,vertical: 24),
          child: CustomActionButton(label: "CheckOut", onPressed: (){
            if(controller.phone.text.isNotEmpty){
              Get.to(CheckOutScreen( totalPrice:food.price,payFailure: (){
                print("payment failure");
              }, paySuccess: (tId) async {
                final isOrderPlaced=await controller.placeOrder(food, quantity, tId);
                if(isOrderPlaced.contains("successfully")){
                  Get.off(() => SucessScreen());
                }
              }));
            }
          },backgroundColor: Color(0xFFFF7622)),
        ),
      ),
    );
  }

  Widget _rowText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

/**/

