import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/log_out_dialog.dart';
import 'package:jalebi_shop_flutter/comman/networkings.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_button.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/home_screen/widgets/custom_text_field.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/home_screen/widgets/fg_password.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/password_reset/controller/reset_screen_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../foods_screen/food_screen.dart';
import '../signup_screen/controllers/signup_controler.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PasswordResetController());

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Reset Password"),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "Reset Password",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 26),
              Text(
                "Enter a strong secure new password",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF32343E),
                ),
              ),
              Text(
                "Use alphabets,numbers,special chars",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF32343E),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Enter New Password",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              ),
              CustomTextField(
                obsecureText: false,
                obsecureText_: () {},
                showTrailing: false,
                hint_text: "New Password",
                text_controller: controller.passwordController,
              ),
              SizedBox(height: 12),
              Text(
                "Confirm Password",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              ),
              CustomTextField(
                obsecureText: false,
                obsecureText_: () {},
                showTrailing: false,
                hint_text: "Re-enter password",
                text_controller: controller.confirmPasswordController,
              ),
              SizedBox(height: 24),
              Center(
                child: CustomActionButton(
                  label: "Change Password",
                  onPressed: () async {
                    if (controller.passwordController.text.isNotEmpty &&
                        controller.confirmPasswordController.text.isNotEmpty) {
                      if (controller.passwordController.text ==
                          controller.confirmPasswordController.text) {
                        showLoadingDialog(context);

                        // Wait for the async function to complete
                        final response = await changePassword(
                          email,
                          controller.confirmPasswordController.text,
                        );

                        final prefs = await SharedPreferences.getInstance();
                        final credentials = prefs.getString('credentials');
                        if (credentials == null) {
                          if (response.contains("error message")) {
                            Get.snackbar(
                              "User Error",
                              response,
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.orange,
                              colorText: Colors.white,
                            );
                          } else {
                            final responseJson = jsonDecode(response);
                            if (responseJson.containsKey("token")) {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setString(
                                'credentials',
                                response.toString(),
                              );
                              Get.to(FoodScreen());
                            } else {
                              Get.snackbar(
                                "User Error",
                                responseJson["error message"],
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.orange,
                                colorText: Colors.white,
                              );
                            }
                          }
                        }else{
                          Get.back();
                          Get.back();
                        }

                      } else {
                        Get.snackbar(
                          "User Error",
                          "Password Not Matching",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.orange,
                          colorText: Colors.white,
                        );
                      }
                    } else {
                      Get.snackbar(
                        "User Error",
                        "Please fill both fields",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                      );
                    }
                  },
                  backgroundColor: Color(0xFFE53935),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
