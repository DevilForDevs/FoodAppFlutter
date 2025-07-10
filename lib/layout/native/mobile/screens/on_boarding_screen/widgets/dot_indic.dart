import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
class DotIndic extends StatelessWidget {
  const DotIndic({
    super.key,
    required PageController controller,
    required this.pages,
  }) : _controller = controller;

  final PageController _controller;
  final List<Map<String, String>> pages;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 39),
      child: SmoothPageIndicator(
        controller: _controller,
        count: pages.length,
        effect: WormEffect(
          dotHeight: 10,
          dotWidth: 10,
          activeDotColor: Color(0xFFEF5350),
          dotColor: Color(0xFFFFCDD2),
        ),
      ),
    );
  }
}