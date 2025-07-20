import 'package:flutter/material.dart';

class VerticalStepperItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isFirst;
  final bool isLast;
  final bool isCompleted;

  const VerticalStepperItem({
    super.key,
    required this.title,
    required this.icon,
    this.isFirst = false,
    this.isLast = false, required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Icon Dot + Line
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration:  BoxDecoration(
                  color: isCompleted?Color(0xFFFF7622):Color(0xFFBFBCBA),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(icon, size: 18, color: Colors.white),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color:isCompleted?Color(0xFFFF7622):Color(0xFFBFBCBA),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Right: Step Text (aligned to top)
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 8), // slight nudge for visual balance
              margin: EdgeInsets.only(bottom: 60),
              alignment: Alignment.topLeft,
              child: Text(
                title,
                style:TextStyle(
                    fontSize: 16,
                  color: isCompleted?Color(0xFFFF7622):Color(0xFFBFBCBA),
                  fontFamily: "Sen",
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
