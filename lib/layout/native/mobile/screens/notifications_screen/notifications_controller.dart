import 'package:get/get.dart';

class NotificationController extends GetxController {
  var notificationsEnabled = true.obs;
  var priceDrop = true.obs;
  var delivery = true.obs;
  var messages = true.obs;
  var promotions = false.obs;

  void toggleAll(bool value) {
    notificationsEnabled.value = value;
    priceDrop.value = value;
    delivery.value = value;
    messages.value = value;
    promotions.value = value;
  }
}
