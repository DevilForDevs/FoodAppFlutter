import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/log_out_dialog.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/credentials_controller.dart';
import 'personal_info_controller.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PersonalInfoController());
    final profileController = Get.find<CredentialController>();
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "My Account",
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      Obx(
                            () => CircleAvatar(
                          radius: 40,
                          backgroundImage: profileController.pickedImage.value != null
                              ? FileImage(profileController.pickedImage.value!) // Use the picked image if available
                              : AssetImage('assets/person.png') as ImageProvider, // Use the default image if not
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Color(0xFFFF7622),
                          child: IconButton(onPressed:(){
                            if(profileController.accountType.value=="individual"){
                              controller.pickImage();
                            }else{
                              Fluttertoast.showToast(
                                msg: "Account not avatar upload",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                fontSize: 16.0,
                              );
                            }

                          }, icon: Icon(Icons.edit, size: 16, color: Colors.white)),
                        ),
                      )
                    ],
                  ),
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
                      onPressed: controller.isEditing.value
                          ? null // ❌ Disable save icon when editing is true
                          : () {
                        // ✅ Toggle edit mode when pencil is clicked
                        controller.isEditing.value = true;
                      },
                      icon: Icon(
                        controller.isEditing.value ? Icons.save : Icons.edit,
                        color: const Color(0xFFFF7622),
                      ),
                    ),
                  ],
                )),
                const SizedBox(height: 12),
                _buildInfoField("Name", controller.nameController, controller),
                const SizedBox(height: 16),
                _buildInfoField("Email", controller.emailController, controller),
                const SizedBox(height: 16),
                /*_buildInfoField("Phone Number", controller.phoneController, controller),
                const SizedBox(height: 24),*/
                _buildInfoField("Bio(Optional)", controller.bioController, controller),
                const SizedBox(height: 24),
                Obx(() {
                  return controller.isEditing.value
                      ? ElevatedButton(
                    onPressed:(){
                      if(profileController.accountType.value=="individual"){
                        showLoadingDialog(context);
                        controller.saveChanges();
                      }else{
                        Fluttertoast.showToast(
                          msg: "Account not support Editing",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          fontSize: 16.0,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),backgroundColor: Color(0xFFFF7622)
                    ),
                    child: const Text("Save",style: TextStyle(color: Colors.white),),
                  )
                      : const SizedBox.shrink();
                }),
                SizedBox(height: 24,),
                GestureDetector(
                  onTap: (){

                    if(profileController.accountType.value=="individual"){
                      controller.updatePassword();
                    }else{
                      Fluttertoast.showToast(
                        msg: "Account not support Password editing",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        fontSize: 16.0,
                      );
                    }

                  },
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

