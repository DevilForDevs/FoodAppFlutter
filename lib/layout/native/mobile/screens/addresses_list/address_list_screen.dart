import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/address_screen/address_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/addresses_list/widgets/address_item.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/credentials_controller.dart';

class AddressListScreen extends StatelessWidget {
  const AddressListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CredentialController>();
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Addresses"),
        body: Obx(() => controller.addresses.isEmpty?Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("You save not saved any address"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: ()=>Get.to(AddressScreen(addressIndex: -1)), icon:Icon(Icons.add,color: Color(0xFFFC6E2A),)),
                  Text("Add Address")
                ],
              )
            ],
          ),):ListView.builder(
          itemCount: controller.addresses.length,
          itemBuilder: (context, index) {
            final address = controller.addresses[index];
            return AddressItemView(address: address, controller: controller,index: index,);
          }
        ))
      ),
    );
  }
}


