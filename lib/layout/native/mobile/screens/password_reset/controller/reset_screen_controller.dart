import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PasswordResetController extends GetxController {
  var obscureText = false.obs;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

}