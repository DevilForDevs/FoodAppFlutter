import 'package:flutter/material.dart';

class DesktopScreen extends StatelessWidget {
  const DesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DesktopScreen')),
      body:  Center(child:OutlinedButton(onPressed: (){}, child: Text("ranjan"))),
    );
  }
}
