import 'package:flutter/material.dart';

class BannerPromo extends StatelessWidget {
  final String imageUrl;

  const BannerPromo({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network(imageUrl, fit: BoxFit.cover),
      ),
    );
  }
}

// banner masih ragu sih
