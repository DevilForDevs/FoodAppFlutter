
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/log_out_dialog.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/address_screen/address_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_button.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/credentials_controller.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/place_order_screen/widgets/order_address_item.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/product_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../commans/custom_app_bar.dart';

class PlaceOrderScreen extends StatelessWidget {
  const PlaceOrderScreen({super.key, required this.food, required this.quantity, required this.discontPrice});
  final ProductModel food;
  final int quantity;
  final int discontPrice;


  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    final controller=Get.find<CredentialController>();
    final isQrSignIN=controller.isQrSignIN.value;
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Order Summary"),
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
            _rowText("Rate :", "₹$discontPrice/${food.unit}"),
            _rowText("Total Price :", "₹${quantity *discontPrice}"),

            SizedBox(height: 8),
            _rowText("Contact :", ""),
            SizedBox(
              width: double.infinity,
              child: TextField(
                controller: controller.phone,
                keyboardType: TextInputType.number,
                maxLength: 12,// Show number keyboard
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(12),// Only allow digits (0-9)
                ],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? Color(0xFF303030) : Color(0xFFF0F5FA),
                  contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  hintText: isQrSignIN?"Not Required":'Enter phone no',
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

            Obx(() => controller.addresses.isEmpty?Column(
              children: [
                Text("No addresses saved yet"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Add Address"),
                    IconButton(onPressed: (){
                      Get.to(AddressScreen(addressIndex: -1));

                    }, icon:Icon(Icons.add,color: Color(0xFFFC6E2A),)),
                  ],
                )

              ],
            ):ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.addresses.length,
              itemBuilder: (context, index) {
                return ProductDetailAddressItem(controller: controller,index: index,);
              },
            )),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24,vertical: 24),
          child: CustomActionButton(label: "CheckOut", onPressed: () async {
            if(controller.addresses.isEmpty){
              final dbPath = await getDatabasesPath();
              final path = join(dbPath, 'address.db');

              await deleteDatabase(path);
              print('Database deleted: $path');
              showLoadingDialog(context);
              await controller.fetchAddress();
              Get.back();
              Fluttertoast.showToast(
                msg: "Address is required",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                fontSize: 16.0,
              );
            }else{
              controller.mplaceOrder(food, quantity,discontPrice);
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

