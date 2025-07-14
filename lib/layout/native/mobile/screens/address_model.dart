import 'package:get/get.dart';

class AddressModel {
  var addressId = 0.obs;
  var userId = 0.obs;
  var city = ''.obs;
  var street = ''.obs;
  var pincode = ''.obs;
  var longAddress = ''.obs;
  var addressType = ''.obs;

  AddressModel({
    required int addressId,
    required int userId,
    required String city,
    required String street,
    required String pincode,
    required String longAddress,
    required String addressType,
  }) {
    this.addressId.value = addressId;
    this.userId.value = userId;
    this.city.value = city;
    this.street.value = street;
    this.pincode.value = pincode;
    this.longAddress.value = longAddress;
    this.addressType.value = addressType;
  }
}






