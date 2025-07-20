import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/search_screen/search_screen_controller.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/search_screen/widgets/search_item.dart';
import '../banner_ad_widget.dart';
import '../commans/top_bar_cart_btn.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchScreenController());
    final isDark = isDarkMode(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true, // ensure layout shifts with keyboard
        appBar: CustomAppBar(
          title: "Search",
          endWidget: TopBarCartButton(),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF303030) : const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Obx(() => TextField(
                      controller: controller.queryController,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                        color: isDark ? Colors.white : const Color(0xFF403F3E),
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF403F3E)),
                        suffixIcon: controller.queryText.value.isEmpty
                            ? null
                            : GestureDetector(
                          onTap: controller.clearQuery,
                          child: const Icon(Icons.close, color: Color(0xFF403F3E)),
                        ),
                        hintText: "What will you like to eat?",
                        hintStyle: const TextStyle(
                          color: Color(0xFF676767),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                        border: InputBorder.none,
                      ),
                    )),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.products.length,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, index) {
                  final product = controller.products[index];
                  return SearchItemView(product: product);
                },
              )),
            ),
          ],
        ),

      ),
    );
  }
}
