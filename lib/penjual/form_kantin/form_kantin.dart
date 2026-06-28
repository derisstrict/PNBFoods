import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pnbfoods/common/forms.dart';
import 'package:pnbfoods/common/tombol.dart';
import 'package:pnbfoods/common/top_bar.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/models/kantin.dart';
import 'package:pnbfoods/services/kantin_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormKantin extends StatefulWidget {
  final Kantin? kantin;

  const FormKantin({super.key, this.kantin});

  @override
  State<FormKantin> createState() => _FormKantinState();
}

class _FormKantinState extends State<FormKantin> {
  late TextEditingController namaKantin;
  late TextEditingController kategori;

  String? selectedKategori;

  final List<String> kategoriList = [
    'Makanan',
    'Minuman',
    'Makanan & Minuman',
    'Snack',
    'Dessert',
  ];

  File? _gambar;

  @override
  void initState() {
    super.initState();

    namaKantin = TextEditingController(
      text: widget.kantin == null ? "" : widget.kantin!.namaKantin,
    );

    kategori = TextEditingController(
      text: widget.kantin == null ? "" : widget.kantin!.kategori,
    );

    if (widget.kantin != null) {
      if (kategoriList.contains(widget.kantin!.kategori)) {
        selectedKategori = widget.kantin!.kategori;
      } else {
        kategoriList.add(widget.kantin!.kategori);
        selectedKategori = widget.kantin!.kategori;
      }
    }
  }

  @override
  void dispose() {
    namaKantin.dispose();
    kategori.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: widget.kantin != null ? "Edit Kantin" : "Tambah Kantin"),
      backgroundColor: Warna.warnaBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: _gambar != null
                          ? Image.file(
                              _gambar!,
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            )
                          : (widget.kantin != null && widget.kantin!.fotoUrl != null)
                              ? Image.network(
                                  widget.kantin!.fotoUrl!,
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.image_not_supported,
                                    color: Warna.warnaTextGray,
                                    size: 60,
                                  ),
                                )
                              : Icon(
                                  Icons.image_not_supported,
                                  color: Warna.warnaTextGray,
                                  size: 60,
                                ),
                    ),
                    const SizedBox(height: 10),
                    TombolNavigasi(
                      function: () async {
                        await pickImage();
                      },
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      text: "Upload gambar",
                    ),
                    const Text(
                      "Ukuran gambar maksimal 5MB",
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Column(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text(
                          "Kantin",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    Form(
                      child: Column(
                        spacing: 15,
                        children: [
                          TextFormFieldCustom(
                            controller: namaKantin,
                            labelText: "Nama Kantin",
                            prefixIcon: const Icon(Icons.edit),
                          ),

                          DropdownFormFieldCustom(
                            value: selectedKategori,
                            labelText: "Kategori",
                            prefixIcon: const Icon(Icons.category),
                            items: kategoriList,
                            onChanged: (value) {
                              setState(() {
                                selectedKategori = value;
                              });
                            },
                          ),
                          Row(
                            children: [
                              TombolNavigasi(
                                function: () {
                                  Navigator.pop(context);
                                },
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                text: "Kembali",
                              ),
                              const Spacer(),
                              TombolNavigasi(
                                function: upsertData,
                                backgroundColor: Warna.warnaAccent,
                                foregroundColor: Colors.white,
                                icon: Icons.check,
                                text: "Simpan",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> upsertData() async {
    if (namaKantin.text.isEmpty ||
        selectedKategori == null ||
        (_gambar == null && widget.kantin == null)) {
      const snackbar = SnackBar(content: Text("Salah satu form belum terisi."));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return;
    }

    try {
      if (widget.kantin == null) {
        final prefs = await SharedPreferences.getInstance();
        final penjualId = prefs.getInt('userId');
        if (penjualId == null) {
          throw Exception("ID Penjual tidak ditemukan. Silakan login kembali.");
        }
        final createdKantin = await postKantin(
          namaKantin: namaKantin.text,
          kategori: selectedKategori!,
          fotoKantin: _gambar!,
          penjualId: penjualId,
        );
        if (!mounted) return;
        Navigator.pop(context, createdKantin);
      } else {
        final updatedKantin = await updateKantin(
          id: widget.kantin!.id,
          namaKantin: namaKantin.text,
          kategori: selectedKategori!,
          fotoKantin: _gambar,
        );
        if (!mounted) return;
        Navigator.pop(context, updatedKantin);
      }
    } catch (e) {
      if (!mounted) return;
      final snackbar = SnackBar(content: Text("Gagal menyimpan data: $e"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? gambar = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (gambar != null) {
      setState(() {
        _gambar = File(gambar.path);
      });
    }
  }
}
