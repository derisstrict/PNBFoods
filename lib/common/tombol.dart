import 'package:flutter/material.dart';

class TombolNavigasi extends StatelessWidget {

  final VoidCallback function;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData? icon;
  final String text;

  const TombolNavigasi({super.key, required this.function, required this.backgroundColor, required this.foregroundColor, this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: function,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10)
        ) 
      ), 
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: icon != null,
            child: Row(
              children: [
                Icon(icon,
                  color: foregroundColor,
                ),
                SizedBox(width: 5,)
              ],
            ) 
          ),
          Text(text,
            style: TextStyle(
              color: foregroundColor
            ),
          )
        ],
      ) 
    );
  }
}