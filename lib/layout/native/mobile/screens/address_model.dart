import 'package:get/get.dart';

class AddressModel {
  var addressId = 0.obs;
  var userId = 0.obs;
  var city = 'Patna'.obs;
  var street = 'Main Street'.obs;
  var pincode = '800001'.obs;
  var building = 'Generic Building'.obs;
  var longAddress = 'Generic Building, Main Street, Patna, Bihar - 800001'.obs;
  var addressType = 'Home'.obs;

  AddressModel({
    int addressId = 0,
    int userId = 0,
    String city = 'Patna',
    String street = 'Main Street',
    String pincode = '800001',
    String building = 'Generic Building',
    String longAddress = 'Generic Building, Main Street, Patna, Bihar - 800001',
    String addressType = 'Home',
  }) {
    this.addressId.value = addressId;
    this.userId.value = userId;
    this.city.value = city;
    this.street.value = street;
    this.pincode.value = pincode;
    this.building.value = building;
    this.longAddress.value = longAddress;
    this.addressType.value = addressType;
  }

  /// ✅ This creates a new instance
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressId: json['address_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      city: json['city'] ?? 'Patna',
      street: json['street'] ?? 'Main Street',
      pincode: json['pincode'] ?? '800001',
      building: json['building'] ?? 'Generic Building',
      longAddress: json['longAddress'] ??
          'Generic Building, Main Street, Patna, Bihar - 800001',
      addressType: json['addressType'] ?? 'Home',
    );
  }
}





