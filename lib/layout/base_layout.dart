import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/platform.dart';
import 'web/web_screen.dart';
import 'native/native_screen.dart';

class BaseLayout extends StatelessWidget {
  const BaseLayout({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return const WebScreen();
    return const NativeScreen();
  }
}
