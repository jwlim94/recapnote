import 'package:flutter/material.dart';
import 'package:recapnote/src/shared/constants/app_colors.dart';

// Example
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final double verticalPadding;
  final double horizontalPadding;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.appBlack,
    this.foregroundColor = AppColors.appWhite,
    this.verticalPadding = 12,
    this.horizontalPadding = 16,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
      ),
      child: Text(text, style: TextStyle(color: foregroundColor)),
    );
  }
}
