import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_button.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/foods_screen/food_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/home_screen/controllers/hide_password.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/home_screen/widgets/auth_txtf_heading.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/home_screen/widgets/custom_text_field.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/home_screen/widgets/fg_password.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/home_screen/widgets/signup_headings.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/home_screen/widgets/signup_sub_heading.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/qr_scanner_screen/qr_scan_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../comman/log_out_dialog.dart';
import '../../../../../comman/networkings.dart';
import '../signup_screen/controllers/signup_controler.dart';
import '../verify_email/verify_email.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeScreenController());
    final signupController = Get.put(SignupScreenController());
    final isDark=isDarkMode(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // center vertically
                crossAxisAlignment:
                    CrossAxisAlignment.start, // center horizontally (optional)
                children: [
                  //bold heading
                  TopHeadingSignup(),
                  SignupSubHeading(),
                  SizedBox(height: 16),
                  AuthTextFieldHeading(hint: "Email Address"),
                  CustomTextField(
                    text_controller: controller.emailController,
                    hint_text: "septa.git@gmail.com",
                    showTrailing: false,
                    obsecureText: false,
                    obsecureText_: () {},
                  ),
                  SizedBox(height: 16),
                  AuthTextFieldHeading(hint: "Password"),
                  Obx(
                    () => CustomTextField(
                      text_controller: controller.passwordController,
                      hint_text: "Your Password",
                      showTrailing: true,
                      obsecureText: controller.obscureText.value,
                      obsecureText_: () {
                        controller.toggleVisibility();
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  ForgotPassword(onPress: (){
                    if(controller.emailController.text.isNotEmpty){
                      showLoadingDialog(context);
                      final ctx=context;
                      void handleSendOtp() async {
                        final response = await sendOtp(controller.emailController.text.trim(), "old");
                        if (response.containsKey('otp')) {
                          signupController.emailController.text=controller.emailController.text;
                          signupController.passwordReset.value=true;
                          signupController.otp.value=int.tryParse(response['otp'].toString())!;
                          hideLoadingDialog(ctx);
                          Get.to(VerifyEmailScreen(emailUpdate: false,displayEmail: controller.emailController.text,otp: signupController.otp.value.toString(),));
                        } else {
                          // Handle error
                          print("Error: ${response['message'] ?? 'Unknown error'}");
                        }
                      }
                      handleSendOtp();

                    }else{
                      Fluttertoast.showToast(
                        msg: "Please Enter registered email",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        fontSize: 16.0,
                      );

                    }
                  },),
                  SizedBox(height: 16),
                  Center(
                    child: CustomActionButton(
                      label: "SIGN IN",
                      backgroundColor: Color(0xFFE53935),
                      onPressed: () async {
                        if(controller.emailController.text.trim().isNotEmpty||controller.passwordController.text.trim().isNotEmpty){
                          final email = controller.emailController.text.trim();
                          final password = controller.passwordController.text.trim();
                          showLoadingDialog(context);
                          if (await checkConnectivity()) {
                            final result = await login(email, password);
                            final parsedJson = jsonDecode(result);
                            if (parsedJson.containsKey("token")) {
                              hideLoadingDialog(context);
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setString('credentials', result); // stores entire JSON string
                              Get.offAll(FoodScreen());
                            } else {
                              Fluttertoast.showToast(
                                msg:result,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                fontSize: 16.0,
                              );
                              hideLoadingDialog(context);
                            }

                          } else {
                            Fluttertoast.showToast(
                              msg:"Please check your internet connection",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              fontSize: 16.0,
                            );
                          }
                        }else{
                          Fluttertoast.showToast(
                            msg:"Please Enter All Fields",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            fontSize: 16.0,
                          );

                        }
                      },
                    ),
                  ),
                  SizedBox(height: 24,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed: ()=>Get.to(QRScannerPage()), icon: Icon(Icons.qr_code,size: 30,color:Color(0xFFE53935),)),
                      Text(
                          "Scan QR to Login",
                        style: TextStyle(
                          fontSize: 18,
                          color: isDark?Colors.white:Colors.black,
                          fontWeight: FontWeight.w700
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
