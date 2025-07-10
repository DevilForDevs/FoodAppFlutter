import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/password_reset/reset_password_screen.dart';
import 'personal_info_controller.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PersonalInfoController());

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "My Account",
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/person.png'), // Replace this
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Color(0xFFFF7622),
                        child: Icon(Icons.edit, size: 16, color: Colors.white),
                      ),
                    )
                  ],
                ),
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      controller.isEditing.value?"Save":"Edit Details",style: TextStyle(
                      color: Color(0xFF181C2E)
                    ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.isEditing.value = !controller.isEditing.value;
                      },
                      icon: Icon(
                        controller.isEditing.value ? Icons.save : Icons.edit,color: Color(0xFFFF7622),
                      ),
                    ),
                  ],
                )),
                const SizedBox(height: 12),
                _buildInfoField("Name", controller.nameController, controller),
                const SizedBox(height: 16),
                _buildInfoField("Email", controller.emailController, controller),
                const SizedBox(height: 16),
                _buildInfoField("Phone Number", controller.phoneController, controller),
                const SizedBox(height: 24),
                _buildInfoField("Bio(Optional)", controller.bioController, controller),
                const SizedBox(height: 24),
                Obx(() {
                  return controller.isEditing.value
                      ? ElevatedButton(
                    onPressed: controller.saveChanges,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),backgroundColor: Color(0xFFFF7622)
                    ),
                    child: const Text("Save",style: TextStyle(color: Colors.white),),
                  )
                      : const SizedBox.shrink();
                }),
                SizedBox(height: 12,),
                GestureDetector(
                  onTap: ()=>Get.to(ResetPasswordScreen()),
                  child: Text(
                    "Reset Password",
                    style: TextStyle(
                      color: Color(0xFFFF7622),
                      fontSize: 16,
                      fontFamily: "Poppins"

                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, TextEditingController controllerField, PersonalInfoController controller) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 4),
        controller.isEditing.value
            ? TextField(
          controller: controllerField,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        )
            : Text(
          controllerField.text,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    ));
  }
}

