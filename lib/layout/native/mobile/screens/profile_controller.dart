
import 'dart:io';

import 'package:get/get.dart';

import 'address_model.dart';

class ProfileController extends GetxController {
  var name="".obs;
  var bio="I love fast food".obs;
  var pinCode="".obs;
  var thumbnail_url="assets/person.png".obs;
  var city="".obs;
  var village="".obs;
  var addressLong="Address".obs;
  var email="".obs;
  AddressModel addresModel=AddressModel(addressId: 0,userId: 0,city: "",street: "Village",pincode: "",longAddress: "Address",addressType: "");
  final cartSize=0.obs;
  final Rx<File?> pickedImage = Rx<File?>(null);
}