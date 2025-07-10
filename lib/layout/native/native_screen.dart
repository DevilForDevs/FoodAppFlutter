import 'package:flutter/material.dart';
import '../../core/platform.dart';
import 'mobile/mobile_screen.dart';
import 'tablet/tablet_screen.dart';
import 'desktop/desktop_screen.dart';
import 'ultra_wide/ultra_wide_screen.dart';

class NativeScreen extends StatelessWidget {
  const NativeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenType = getDeviceType(context);
    switch (screenType) {
      case DeviceScreenType.mobile:
        return const MobileScreen();
      case DeviceScreenType.tablet:
        return const TabletScreen();
      case DeviceScreenType.desktop:
        return const DesktopScreen();
      case DeviceScreenType.ultraWide:
        return const UltraWideScreen();
    }
  }
}
