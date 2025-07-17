import 'package:flutter/material.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';

import '../../address_model.dart';
import '../address_screen_controller.dart';
class AddressItemView extends StatelessWidget {
  const AddressItemView({
    super.key,
    required this.address,
    required this.controller, required this.index,
  });


  final AddressModel address;
  final AddressScreenController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isDark=isDarkMode(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFFFF7622)),
                  onPressed: () => controller.editAddress(index),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(address.longAddress.value),
          ],
        ),
      ),
    );
  }
}