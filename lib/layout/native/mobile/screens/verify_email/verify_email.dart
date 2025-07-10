import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/networkings.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_button.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/foods_screen/food_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/signup_screen/controllers/signup_controler.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/verify_email/verify_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../password_reset/reset_password_screen.dart';
import '../signup_screen/widgets/whatsapp_otp_style.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller=Get.put(VerifyEmailController());
    final signupController=Get.put(SignupScreenController());
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Verify",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 24,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter the 4-Digit code sent to",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF32343E),
                    ),
                  ),
                  Text(
                    "you",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "on ${signupController.emailController.text}",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),

                ],
              ),
              SizedBox(height: 24,),
              Row(
                children: [
                  Text(
                    "Didn’t receive ?",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    " Send again",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE53935),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24,),
              Center(
                child: Text(
                  "Resend in 32",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              WhatsAppOtpField(),
              SizedBox(height: 30,),
              Center(child: CustomActionButton(label: "Verify", backgroundColor:Color(0xFFE53935),onPressed: (){
                if(controller.fullOtp==signupController.otp.toString()){
                  void handleSendOtp() async {
                    if(signupController.passwordReset.value){
                      Get.to(ResetPasswordScreen());
                    }else{
                      final response = await registerUser(
                        signupController.nameController.text.trim(),
                        signupController.emailController.text.trim(),
                        signupController.passwordController.text,
                        "individual",
                      );
                      if (response.containsKey("token")) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('credentials',response.toString() );
                        Get.to(FoodScreen());
                      } else {
                        print("Registration failed: ${response['error'] ?? 'Unknown error'}");
                      }
                    }
                  }
                  handleSendOtp();
                }
              })),
              SizedBox(height: 30,),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("By signing up, you have agreed to our ",style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF868686)
                    ),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap:(){},
                          child: Text("Terms and conditions",style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF3567E7)
                          ),),
                        ),
                        Text(" &",style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF868686)
                        ),),
                        GestureDetector(
                          onTap: (){},
                          child: Text(" Privacy policy",style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF3567E7)
                          ),),
                        ),
                      ],
                    )

                  ],
                ),
              )


            ],
          ),
        ),
      ),
    );
  }
}

