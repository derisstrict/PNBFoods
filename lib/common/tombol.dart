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
                if (text != '')
                  SizedBox(width: 5,)
              ],
            ) 
          ),
          Text(text,
            style: TextStyle(
              color: foregroundColor,
              fontWeight: FontWeight.w400
            ),
          )
        ],
      ) 
    );
  }
}

class TombolLebar extends StatelessWidget {

  final VoidCallback function;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData? icon;
  final String text;

  const TombolLebar({super.key, required this.function, required this.backgroundColor, required this.foregroundColor, this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: TextButton(
        onPressed: function,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(15),
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
                    size: 24.0,
                  ),
                  SizedBox(width: 5,)
                ],
              ) 
            ),
            Text(text,
              style: TextStyle(
                color: foregroundColor,
                fontSize: 12.0,
                fontWeight: FontWeight.w400
              ),
            )
          ],
        ) 
      ),
    ); 
  }
}