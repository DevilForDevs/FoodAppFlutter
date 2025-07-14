import 'package:flutter/material.dart';

class ThinTextFileEditor extends StatelessWidget {
  final TextEditingController controller;

   ThinTextFileEditor({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontSize: 12,          // Smallest readable size
        height: 1.0,           // Tight line spacing
      ),
      cursorColor: Colors.blueAccent,
      maxLines: null,          // Allows multiline
      decoration: const InputDecoration(
        isCollapsed: true,     // Removes extra padding
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
