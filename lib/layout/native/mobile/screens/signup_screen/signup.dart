import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/log_out_dialog.dart';
import 'package:jalebi_shop_flutter/comman/networkings.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/home_screen/home_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/home_screen/widgets/auth_txtf_heading.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/signup_screen/controllers/signup_controler.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/verify_email/verify_email.dart';

import '../commans/custom_button.dart';
import '../home_screen/widgets/custom_text_field.dart';


class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupScreenController());
    final isDark=isDarkMode(context);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Let's",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: isDark?Colors.white:Color(0xFF32343E),
                          ),
                        ),
                        Text(
                          " Sign you up",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Color(0xFFF44336),
                          ),
                        ),
                        Text(
                          ",",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Color(0xFF32343E),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "your meal awaits",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: isDark?Colors.white:Color(0xFF32343E),
                          ),
                        ),
                        //subtitle
                        SizedBox(height: 12),
                        Text(
                          "If you have an account",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: isDark?Colors.white:Color(0xFF646982),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Please",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: isDark?Colors.white:Color(0xFF646982),
                              ),
                            ),
                            GestureDetector(
                              onTap: ()=>Get.to(HomeScreen()),
                              child: Text(
                                " Sign in here",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xFFF44336),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16,),
                    AuthTextFieldHeading(hint: "Full Name"),
                    SizedBox(height: 4,),
                    CustomTextField(text_controller:controller.nameController,hint_text:"Septa",showTrailing:false,obsecureText: false, obsecureText_: (){}),

                    SizedBox(height: 16,),
                    AuthTextFieldHeading(hint: "Email"),
                    SizedBox(height: 4,),
                    CustomTextField(text_controller:controller.emailController,hint_text:"septa.git@gmail.com",showTrailing:false,obsecureText: false, obsecureText_: (){}),

                    SizedBox(height: 16,),
                    AuthTextFieldHeading(hint: "Password"),
                    SizedBox(height: 4,),
                    Obx(()=>CustomTextField(text_controller:controller.passwordController,hint_text:"Your Password",showTrailing:true,obsecureText: controller.obscureText.value, obsecureText_: (){
                      controller.toggleVisibility();
                    })),

                    SizedBox(height: 16,),
                    AuthTextFieldHeading(hint: "Confirm Password"),
                    SizedBox(height: 4,),
                    Obx(()=>CustomTextField(text_controller:controller.confirmPasswordController,hint_text:"Your Password",showTrailing:true,obsecureText: controller.obscureText.value, obsecureText_: (){
                      controller.toggleVisibility();
                    })),

                    SizedBox(height: 16),
                    Center(child: CustomActionButton(label: "SIGN UP", onPressed: (){
                      showLoadingDialog(context);
                      if(controller.validateInputs()){
                        void handleSendOtp() async {
                          final response = await sendOtp(controller.emailController.text.trim(), "new");
                          if (response.containsKey('otp')) {
                            controller.otp.value=int.tryParse(response['otp'].toString())!;
                            Get.back();
                            Get.to(VerifyEmailScreen(emailUpdate: false,displayEmail: controller.emailController.text,otp:controller.otp.value.toString() ,));
                          } else {
                            Fluttertoast.showToast(
                              msg: response["error message"],
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              fontSize: 16.0,
                            );
                            Get.back();
                          }
                        }
                        handleSendOtp();
                      }else{
                        Get.back();
                      }
                    },backgroundColor: Color(0xFFE53935),)),
                    SizedBox(height: 24,),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("By signing up, you have agreed to our ",style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color:isDark?Colors.white: Color(0xFF868686)
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
                                  color: isDark?Colors.white:Color(0xFF868686)
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
          ),
        ),
      ),
    );
  }

}
