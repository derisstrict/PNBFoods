import 'dart:io';
import 'package:flutter/material.dart';

class PengambilanKantin extends StatelessWidget {
  final String namaKantin;
  final String? fotoUrl;

  const PengambilanKantin({super.key, required this.namaKantin, this.fotoUrl});

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
            'Pengambilan di Kantin',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  width: 36,
                  height: 36,
                  color: Colors.grey[200],
                  child: fotoUrl == null || fotoUrl!.isEmpty
                      ? const Icon(Icons.store, size: 20)
                      : (fotoUrl!.startsWith('http')
                          ? Image.network(
                              fotoUrl!,
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.store, size: 20),
                            )
                          : Image.file(
                              File(fotoUrl!),
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.store, size: 20),
                            )),
                ),
              ),
              const SizedBox(width: 10),
              Text(namaKantin, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}