import 'package:flutter/material.dart';
class CustomActionButtonAd extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double elevation;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const CustomActionButtonAd({
    Key? key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = Colors.orange,
    this.textColor = Colors.white,
    this.elevation = 2.0,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(borderRadius),
      color: backgroundColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onPressed,
        child: Padding(
          padding: padding,
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
