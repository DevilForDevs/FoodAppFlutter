import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalInfoController extends GetxController {
  var isEditing = false.obs;

  final nameController = TextEditingController(text: "John Doe");
  final emailController = TextEditingController(text: "john@example.com");
  final phoneController = TextEditingController(text: "+91 9876543210");
  final bioController = TextEditingController(text: "Snack Lover");

  void toggleEdit() {
    isEditing.value = !isEditing.value;
  }

  void saveChanges() {
    isEditing.value = false;
    // You can implement saving logic here.
  }
}
