import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;
  var isLastPage = false.obs;

  void updatePage(int index, int totalPages) {
    currentPage.value = index;
    isLastPage.value = index == totalPages - 1;
  }
}
