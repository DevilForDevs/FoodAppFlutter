import 'package:flutter/material.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import '../place_order_screen_controller.dart';
class ProductDetailAddressItem extends StatelessWidget {
  const ProductDetailAddressItem({
    super.key,
    required this.index, required this.controller,
  });

  final PlaceOrderScreenController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isDark=isDarkMode(context);
    final addressItem=controller.addressList[index];
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
                    addressItem.addressType,
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
                  onPressed: (){},
                ),
              ],
            ),
            const SizedBox(height: 4),
            GestureDetector(
                onTap:(){
                  controller.selectedAddressIndex.value=index;
                },
                child: Text(addressItem.longAddress)
            ),
          ],
        ),
      ),
    );
  }
}