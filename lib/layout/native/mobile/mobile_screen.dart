import 'package:flutter/material.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/foods_screen/food_screen.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/on_boarding_screen/on_boarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MobileScreen extends StatelessWidget {
  const MobileScreen({super.key});

  Future<bool> _checkCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('credentials');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkCredentials(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData && snapshot.data == true) {
          return FoodScreen();
        } else {
          return OnBoardingScreen();
        }
      },
    );
  }
}
