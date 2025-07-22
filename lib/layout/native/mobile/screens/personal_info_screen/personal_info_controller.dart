import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:jalebi_shop_flutter/comman/networkings.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/credentials_controller.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/password_reset/reset_password_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/personal_info_screen/upload_progess_dialog.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/verify_email/verify_email.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInfoController extends GetxController {
  final isEditing = false.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  final bioController = TextEditingController();




  final profileController = Get.find<CredentialController>();



  // Original values to track changes
  late String originalName;
  late String originalEmail;

  late String originalBio;
  var token="".obs;
  var userId=0.obs;
  var mProgress = 0.0.obs;
  var isUploading = false.obs;
  @override
  Future<void> onInit() async {
    super.onInit();

    // Initialize original values from profileController
    originalName = profileController.name.value;
    originalEmail = profileController.email.value;
    originalBio = profileController.bio.value;

    // Populate controllers with initial values
    nameController.text = originalName;
    emailController.text = originalEmail;

    bioController.text = originalBio;
    final prefs = await SharedPreferences.getInstance();
    final credentials = prefs.getString('credentials');

    if (credentials != null) {
      final decodedJson = jsonDecode(credentials);
      print(decodedJson);
      userId.value = decodedJson["user"]["id"];
      token.value = decodedJson["token"];
    }
  }
  void toggleEdit() {
    isEditing.value = !isEditing.value;
  }


  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileController.pickedImage.value = File(image.path);
      isUploading.value = true;
      Get.dialog(UploadProgressDialog(), barrierDismissible: false);
      avatarUpload(
        file: profileController.pickedImage.value!,
        accessToken: token.value,
        userId: userId.value,
        listener: (progress, message) async {
          mProgress.value=progress.toDouble();
          if(progress==-1){
            Fluttertoast.showToast(
              msg: "Upload Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              fontSize: 16.0,
            );
            Get.back();
          }
          if(progress==100){
            isUploading.value=false;
            if(message.startsWith("http")){
              final response=await updateAvatar(message, token.value);
              if(response.contains("successfully")){
                final prefs = await SharedPreferences.getInstance();
                final credentials = prefs.getString('credentials');

                if (credentials != null) {
                  final decodedJson = jsonDecode(credentials);
                  decodedJson["user"]["avatar"] = image.path; // or use the final URL if you get it
                  await prefs.setString('credentials', jsonEncode(decodedJson)); // ✅ fixed
                  Get.back();
                }
              }else{
                Fluttertoast.showToast(
                  msg: "Failed to update",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  fontSize: 16.0,
                );
                Get.back();
              }

            }
          }
        },
      );


    }
  }


  Future<void> saveChanges() async {
    final currentName = nameController.text.trim();
    final currentEmail = emailController.text.trim();
    final currentBio = bioController.text.trim();

    if (currentName != originalName) {
      if(token.value.isNotEmpty){
        final response= await updateProfileName(currentName,token.value);
        Get.back();
        if(response.contains("successfully")){
          final prefs = await SharedPreferences.getInstance();
          final credentials = prefs.getString('credentials');

          if (credentials != null) {
            final decodedJson = jsonDecode(credentials);
            decodedJson["user"]["name"] = currentName;
            await prefs.setString('credentials', jsonEncode(decodedJson));
            profileController.name.value=currentName;
          }
        }
      }
      profileController.name.value = currentName;
    }

    if (currentEmail != originalEmail) {

      final response = await sendOtp(currentEmail.trim(), "new");
      Get.back();
      if (response.containsKey('otp')) {
        Get.to(VerifyEmailScreen(emailUpdate: true,displayEmail: currentEmail,otp:response['otp'].toString(),));
        profileController.email.value = currentEmail;

      }
    }

    if (currentBio != originalBio) {
      final prefs = await SharedPreferences.getInstance();
      final credentials = prefs.getString('credentials');
      if(credentials!=null){
        final decodedJson = jsonDecode(credentials);
        decodedJson["user"]["bio"] = currentBio;
        await prefs.setString('credentials', jsonEncode(decodedJson));
      }
      profileController.bio.value = currentBio;
      Get.back();


    }

    isEditing.value = false;
  }
  void updatePassword(){
    Get.to(ResetPasswordScreen(email: emailController.text.trim(),));
  }





  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
    super.onClose();
  }
}
