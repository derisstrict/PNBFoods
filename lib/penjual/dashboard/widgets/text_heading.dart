import 'package:flutter/material.dart';

class TextHeading extends StatelessWidget {
  final String title;

  const TextHeading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: [
        Text(title, 
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16
          ),
        )
      ],
    );
  }
}