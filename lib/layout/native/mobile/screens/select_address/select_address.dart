import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/credentials_controller.dart';

import '../place_order_screen/widgets/order_address_item.dart';

class SelectAddressScreen extends StatelessWidget {
  const SelectAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller=Get.find<CredentialController>();

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Select Address"),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Obx(() => controller.addresses.isEmpty?Column(
            children: [
              Text("No addresses saved yet"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Add Address"),
                  IconButton(onPressed: (){
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

        ),
      ),
    );
  }
}
