import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';

import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_button.dart';

import 'notifications_controller.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());
    final isDark=isDarkMode(context);

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Notifications'),
        body: Obx(
              () => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSwitchTile(
                title: "Enable Notifications",
                value: controller.notificationsEnabled.value,
                onChanged: (val) => controller.toggleAll(val),
              ),
              const Divider(height: 32),

              Opacity(
                opacity: controller.notificationsEnabled.value ? 1.0 : 0.4,
                child: Container(
                  color:isDark?Color(0xFF303030):Color(0xFFECF0F4) ,
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      _buildSwitchTile(
                        title: "Price Drop Alerts",
                        subtitle: "Get updates on price discounts",
                        value: controller.priceDrop.value,
                        onChanged: controller.notificationsEnabled.value
                            ? (val) => controller.priceDrop.value = val
                            : null,
                      ),
                      _buildSwitchTile(
                        title: "Delivery Notifications",
                        subtitle: "Track order and delivery updates",
                        value: controller.delivery.value,
                        onChanged: controller.notificationsEnabled.value
                            ? (val) => controller.delivery.value = val
                            : null,
                      ),
                      _buildSwitchTile(
                        title: "Messages",
                        subtitle: "Get important messages",
                        value: controller.messages.value,
                        onChanged: controller.notificationsEnabled.value
                            ? (val) => controller.messages.value = val
                            : null,
                      ),
                      _buildSwitchTile(
                        title: "Promotions",
                        subtitle: "Offers and deals you might like",
                        value: controller.promotions.value,
                        onChanged: controller.notificationsEnabled.value
                            ? (val) => controller.promotions.value = val
                            : null,
                      ),
                      SizedBox(height: 24,),
                      CustomActionButton(label: "Save", onPressed: (){},backgroundColor:  Color(0xFFFF7622),)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return SwitchListTile(
      value: value,
      activeColor:Color(0xFFFB6F3D),
      inactiveThumbColor:Color(0xFFFB4A59),
      onChanged: onChanged,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: subtitle != null ? Text(subtitle) : null,
    );
  }
}
