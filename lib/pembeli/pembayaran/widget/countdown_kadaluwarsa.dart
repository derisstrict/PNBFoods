import 'package:flutter/material.dart';

class CountdownKadaluwarsa extends StatelessWidget {
  final String formatWaktu;

  const CountdownKadaluwarsa({
    super.key,
    required this.formatWaktu,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Kadaluwarsa dalam ',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text(
                formatWaktu,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}