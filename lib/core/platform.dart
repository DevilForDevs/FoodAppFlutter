import 'package:flutter/material.dart';

enum DeviceScreenType { mobile, tablet, desktop, ultraWide }

DeviceScreenType getDeviceType(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width >= 1440) return DeviceScreenType.ultraWide;
  if (width >= 1024) return DeviceScreenType.desktop;
  if (width >= 600) return DeviceScreenType.tablet;
  return DeviceScreenType.mobile;
}
