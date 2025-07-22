import 'package:flutter/material.dart';

import '../../../../../../comman/sys_utilities.dart';
class IncomingMessage extends StatelessWidget {
  const IncomingMessage({
    super.key,
    required this.message,
  });
  final String message;


  @override
  Widget build(BuildContext context) {

    final isDark=isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.only(top: 20),
          child: ClipOval(
            child: Image.asset(
              "assets/person.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 8),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end, // ← date aligns left
            children: [
              // Date text (now left aligned)
              Text(
                "July 1, 2025",
                style:  TextStyle(fontSize: 12, color: isDark?Colors.white:Color(0xFF1A1817)),
              ),
              const SizedBox(height: 4),

              // Chat bubble
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color:isDark?Color(0xFF212121):Color(0xFFF0F5FA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  message,
                  style: TextStyle(fontSize: 14, color: isDark?Colors.white:Colors.black),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }
}