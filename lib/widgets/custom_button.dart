import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final double? width;

  const CustomButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    double textSize = 16.0;
    if (text.length > 9) {
      textSize = 12.0;
    }

    return SizedBox(
      width: width,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 30,
          color: Colors.blue,
        ),
        label: Text(
          text,
          style: TextStyle(
            fontSize: textSize,
            color: Colors.blue, // Color del texto azul
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        ),
      ),
    );
  }
}
