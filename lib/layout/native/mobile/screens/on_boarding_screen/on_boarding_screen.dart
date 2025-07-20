import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/on_boarding_screen/widgets/dot_indic.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/on_boarding_screen/widgets/on_boarding_body.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/on_boarding_screen/widgets/skip_on_boarding.dart';
import '../home_screen/home_screen.dart';
import 'controllers/on_br_c.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller0 = PageController();
    final controller = Get.put(OnboardingController());
    final List<Map<String, String>> pages = [
      {
        "image": "assets/onb1.png",
        "title": "All your favorites",
        "subtitle": "Get all your loved foods in one place,\nyou just place the order_tracking_screen, we do the rest",
      },
      {
        "image": "assets/onb2.png",
        "title": "Fast Delivery",
        "subtitle": "Experience fast delivery\n at your doorstep in minutes",
      },
      {
        "image": "assets/onb3.png",
        "title": "Live Tracking",
        "subtitle": "Get all your loved foods in one once place,\nfrom our app anytime",
      },
    ];
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 400, // Give PageView a fixed height to avoid Expanded
                child: PageView.builder(
                  controller: controller0,
                  onPageChanged: (index) {
                    controller.updatePage(index, pages.length);
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    final page = pages[index];
                    return OnBoardingBody(page: page);
                  },
                ),
              ),
              const SizedBox(height: 32),
              DotIndic(controller: controller0, pages: pages),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: const Color(0xFFFFCA28),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (controller.isLastPage.value) {
                        Get.to(() => const HomeScreen());
                      } else {
                        controller0.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Obx(
                      () => Text(
                        controller.isLastPage.value ? "Get Started" : "NEXT",
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => Visibility(
                  visible: !controller.isLastPage.value,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: SkipButtonOnBoarding(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
