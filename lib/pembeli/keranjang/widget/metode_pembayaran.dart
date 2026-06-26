import 'package:flutter/material.dart';
import 'package:pnbfoods/common/warna.dart';

class MetodePembayaran extends StatelessWidget {
  const MetodePembayaran({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Metode Pembayaran',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Warna.warnaBackground,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/QRIS_Logo.svg/330px-QRIS_Logo.svg.png', 
                  height: 12,
                  fit: BoxFit.cover, 
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 12,
                    height: 12,
                    color: Warna.warnaBackground,
                    child: Icon(Icons.image_not_supported, size: 12, color: Colors.black,),
                  )
                )
              ),
              const SizedBox(width: 10),
              const Text('QRIS', style: TextStyle(fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}