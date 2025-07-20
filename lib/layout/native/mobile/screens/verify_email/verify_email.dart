import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/networkings.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_button.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/foods_screen/food_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/signup_screen/controllers/signup_controler.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/verify_email/verify_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../comman/legal_texts.dart';
import '../legal_screen/legal_screen.dart';
import '../password_reset/reset_password_screen.dart';
import '../signup_screen/widgets/whatsapp_otp_style.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, required this.emailUpdate, required this.displayEmail, required this.otp});
  final bool emailUpdate;
  final String displayEmail;
  final String otp;

  @override
  Widget build(BuildContext context) {
    final isDark=isDarkMode(context);
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
                  color: isDark?Colors.white:Colors.black,
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
                      color:isDark?Colors.white: Color(0xFF32343E),
                    ),
                  ),
                  Text(
                    "you",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      color:isDark?Colors.white:  Colors.black,
                    ),
                  ),
                  Text(
                    "on $displayEmail",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      color: isDark?Colors.white: Colors.black,
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
                      color: isDark?Colors.white: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      controller.sendOtpAgain(displayEmail);
                    },
                    child: Text(
                      " Send again",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE53935),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24,),
              Center(
                child: Obx(()=> Text(
                    controller.countdown.value>0?"Resend in ${controller.countdown.value}":"",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color:isDark?Colors.white:  Colors.black,
                    ),
                  ),
                ),
              ),
              WhatsAppOtpField(),
              SizedBox(height: 30,),
              Center(child: CustomActionButton(label: "Verify", backgroundColor:Color(0xFFE53935),onPressed: (){
                if(controller.fullOtp==otp){
                  void handleSendOtp() async {
                    if(emailUpdate){
                      final prefs = await SharedPreferences.getInstance();
                      final credentials = prefs.getString('credentials');

                      if (credentials != null) {
                        final decodedJson = jsonDecode(credentials);

                        final authToken = decodedJson["token"];
                        final response=await updateProfileEmail(displayEmail.trim(), authToken);
                        if(response.contains("Duplicate entry")){

                        }else{

                          final decodedJson = jsonDecode(credentials);
                          decodedJson["user"]["email"] =displayEmail;
                          await prefs.setString('credentials', jsonEncode(decodedJson));
                          Get.back();

                        }
                       
                      }

                    }else{
                      if(signupController.passwordReset.value){
                        Get.to(ResetPasswordScreen(email: displayEmail,));
                      }else{
                        final name=signupController.nameController.text.trim();
                        final email=signupController.emailController.text.trim();
                        final password=signupController.confirmPasswordController.text.trim();
                        final response = await signup(
                          name: name,email: email,password: password,accountType: "individual"
                        );
                        if(response.contains("token")){
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('credentials',response.toString() );
                          Get.offAll(()=>FoodScreen());
                        }else{
                          final decodejson=jsonDecode(response);
                          Fluttertoast.showToast(
                            msg: decodejson["message"],
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                        }
                      }
                    }
                  }
                  handleSendOtp();
                }else{
                  Fluttertoast.showToast(
                    msg: "Wrong otp",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                  );
                  controller.clearOtp();
                }
              })),
              SizedBox(height: 30,),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Text("By signing up, you have agreed to our ",style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF868686)
                      ),),
                      onTap: (){},
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap:()=>Get.to(LegalScreen(title: "Privacy Policy", content: LegalTexts.privacyPolicy)),
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
                          onTap: ()=>Get.to(LegalScreen(title: "Privacy Policy", content: LegalTexts.privacyPolicy)),
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

