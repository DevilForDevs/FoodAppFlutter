import 'package:flutter/material.dart';
import '../../core/platform.dart';
import 'mobile/web_mobile_screen.dart';
import 'tablet/web_tablet_screen.dart';
import 'desktop/web_desktop_screen.dart';
import 'ultra_wide/web_ultrawide_screen.dart';

class WebScreen extends StatelessWidget {
  const WebScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenType = getDeviceType(context);
    switch (screenType) {
      case DeviceScreenType.mobile:
        return const WebMobileScreen();
      case DeviceScreenType.tablet:
        return const WebTabletScreen();
      case DeviceScreenType.desktop:
        return const WebDesktopScreen();
      case DeviceScreenType.ultraWide:
        return const WebUltraWideScreen();
    }
  }
}
