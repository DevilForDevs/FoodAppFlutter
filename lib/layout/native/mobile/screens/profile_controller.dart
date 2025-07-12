
import 'package:get/get.dart';

import 'address_model.dart';

class ProfileController extends GetxController {
  var name="".obs;
  var pinCode="".obs;
  var thumbnail_url="".obs;
  var city="".obs;
  var village="".obs;
  var addressLong="".obs;
  AddressModel addresModel=AddressModel();
  final cartSize=0.obs;
}