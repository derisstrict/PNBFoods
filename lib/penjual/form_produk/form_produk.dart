import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pnbfoods/common/forms.dart';
import 'package:pnbfoods/common/tombol.dart';
import 'package:pnbfoods/common/top_bar.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/models/produk.dart';
import 'package:pnbfoods/services/produk_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormProduk extends StatefulWidget {
  final Produk? produk;

  const FormProduk({super.key, this.produk});

  @override
  State<FormProduk> createState() => _FormProdukState();
}

class _FormProdukState extends State<FormProduk> {

  TextEditingController? nama;
  TextEditingController? harga;
  TextEditingController? deskripsi;
  TextEditingController? stok;
  File? _gambar;
  String? _memStok;

  bool? _nilaiCheckbox;
  String? _kategori;

  // String? _appDirPath = "";

  Future<void> _initPath() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    setState(() {
      // _appDirPath = appDir.path;
    });
  }

  @override
  void initState() {
    nama = TextEditingController(
      text: widget.produk == null ? "" : widget.produk!.namaProduk
    );
    harga = TextEditingController(
      text: widget.produk == null ? "" : widget.produk!.hargaProduk.toString()
    );
    deskripsi = TextEditingController(
      text: widget.produk == null ? "" : widget.produk!.deskripsiProduk
    );
    stok = TextEditingController(
      text: widget.produk == null ? "1" : widget.produk!.stok.toString()
    );
    _kategori = widget.produk == null ? "Makanan" : widget.produk!.kategoriProduk;
    _nilaiCheckbox = stok!.text != "-1";
    if (widget.produk != null) {
      _memStok = widget.produk!.stok == -1 ? "1" : widget.produk!.stok.toString();
    }
    super.initState();
    _initPath();
  }

  @override
  Widget build(BuildContext context) {
    // File fileGambar = File(p.join(_appDirPath!, gambar)); 
    return Scaffold(
      appBar: TopBar(title: widget.produk == null ? "Tambah Produk" : "Edit Produk"),
      backgroundColor: Warna.warnaBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_gambar != null) ...[
                            Image.file(_gambar!, height: 80, width: 80, fit: BoxFit.cover)
                          ] else if (widget.produk?.fotoUrl != null) ...[
                            Image.network(widget.produk!.fotoUrl!, height: 80, width: 80, fit: BoxFit.cover)
                          ] else ...[
                            Icon(Icons.image_not_supported, color: Warna.warnaTextGray, size: 60)
                          ]
                        ],
                      ) 
                    ),
                    SizedBox(height: 10,),
                    TombolNavigasi(
                      function: () async {
                        await pickImage();
                      }, 
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black, 
                      text: "Upload gambar"
                    ),
                    Text("Ukuran gambar maksimal 5MB",
                    style: TextStyle(
                      fontSize: 10
                    ),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                Column(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Produk",
                          textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16
                            ),
                          ), 
                      ],
                    ),
                    Form(
                      child: Column(
                        spacing: 15,
                        children: [
                          TextFormFieldCustom(
                            controller: nama!, 
                            labelText: "Nama Produk", 
                            prefixIcon: Icon(Icons.edit) 
                          ),
                          TextFormFieldCustom(
                            controller: harga!, 
                            labelText: "Harga", 
                            prefixIcon: Padding(
                              padding: EdgeInsetsGeometry.only(top: 13, left: 10, bottom: 12),
                              child: Text("Rp.",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Warna.warnaAccent
                                ),),
                            ),
                            numberOnly: true,
                          ),
                          DropdownButtonFormFieldCustom(
                            initialValue: _kategori, 
                            icon: Icons.category,
                            items: [
                              DropdownMenuItem(
                                value: "Makanan",
                                child: Text("Makanan")
                              ),
                              DropdownMenuItem(
                                value: "Minuman",
                                child: Text("Minuman")
                              )
                            ], 
                            onChanged: (value) {
                              _kategori = value;
                            }
                          ),
                          TextArea(
                            controller: deskripsi!, 
                            minLines: 4, 
                            maxLines: 4, 
                            icon: Icons.description_outlined, 
                            title: "Deskripsi"
                          ),
                          Stok(
                            controller: stok!,
                            checkboxValue: _nilaiCheckbox!,
                            enabled: (value) {
                              setState(() {
                                _nilaiCheckbox = value;
                                if (!value) {
                                  if (stok!.text != "-1") {
                                    _memStok = stok!.text;
                                  }
                                  stok!.text = "-1";
                                } else {
                                  stok!.text = _memStok!;
                                }
                              });
                            },
                            onPressedMinus: () {
                              int stokInt = int.parse(stok!.text);
                              if (stokInt > 0) {
                                stokInt = stokInt - 1;
                                setState(() {
                                  stok!.text = stokInt.toString();
                                });
                              }
                            },
                            onPressedPlus: () {
                              int stokInt = int.parse(stok!.text);
                              if (stokInt < 999) {
                                stokInt = stokInt + 1;
                                setState(() {
                                  stok!.text = stokInt.toString();
                                });
                              }
                            },
                            onTapOutside: (tap) {
                              setState(() {
                                if (stok!.text == "") {
                                  stok!.text = "1";
                                }
                              });
                            }
                          ),
                          Row(
                            children: [
                              TombolNavigasi(
                                function: () {
                                  Navigator.pop(context, true);
                                }, 
                                backgroundColor: Colors.white, 
                                foregroundColor: Colors.black,
                                text: "Kembali",
                              ),
                              Spacer(),
                              if (widget.produk != null) 
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TombolNavigasi(
                                      function: _konfirmasiHapus, 
                                      backgroundColor: Colors.red, 
                                      foregroundColor: Colors.white, 
                                      icon: Icons.delete_outline,
                                      text: "Hapus",
                                    ),
                                    // Spacer(),
                                  ],
                                ),
                              Spacer(),
                              TombolNavigasi(
                                function: upsertData, 
                                backgroundColor: Warna.warnaAccent, 
                                foregroundColor: Colors.white, 
                                icon: Icons.check,
                                text: "Simpan",
                              )
                            ],
                          )
                          
                        ],
                      )
                    ),
                  ],
                ),
              ],
            )
          ),
        ) 
      ),
    );
  }

  Future<void> upsertData() async {
    if (nama!.text == '' || harga!.text == '') {
      const snackbar = SnackBar(
        content: Text("Salah satu form belum terisi")
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return;
    }

    if (widget.produk == null) {
      if (_gambar == null) {
        const snackbar = SnackBar(
          content: Text("Silahkan upload gambar")
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        return;
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final penjual_id = prefs.getInt('userId');

    try {
      if (widget.produk == null) {
        await postProduk(
          namaProduk: nama!.text, 
          deskripsiProduk: deskripsi!.text, 
          hargaProduk: int.parse(harga!.text), 
          kategoriProduk: _kategori!, 
          stok: int.parse(stok!.text), 
          penjualId: penjual_id!,
          fotoProduk: _gambar!
        );
        Navigator.pop(context, true);
      } else {
        await updateProduk(
          idProduk: widget.produk!.id, 
          namaProduk: nama!.text, 
          deskripsiProduk: deskripsi!.text, 
          hargaProduk: int.parse(harga!.text), 
          kategoriProduk: _kategori!, 
          stok: int.parse(stok!.text),
          penjualId: penjual_id!,
          fotoProduk: _gambar
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      final snackbar = SnackBar(content: Text("Gagal menyimpan data: $e"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> pickImage() async {
    var maxFileSizeInBytes = 5 * 1048576;

    final ImagePicker picker = ImagePicker();
    
    final XFile? gambar = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80,);

    if (gambar != null) {
      var imagePath = await gambar.readAsBytes();
      var fileSize = imagePath.length;
      if (fileSize <= maxFileSizeInBytes) {
        setState(() {
          _gambar = File(gambar.path);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ukuran gambar melebihi batas maksimum 5MB'), backgroundColor: Colors.red,),
        );
      }
    }
  }

  Future<void> _konfirmasiHapus() async {
    final bool? konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("Hapus Produk"),
            content: Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Apakah anda yakin ingin menghapus produk ini?",
                ),
              ],
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black
                    ),
                    child: const Text("Batal",
                      style: TextStyle(
                        color: Colors.black
                      ),
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.white,),
                        Text("Hapus",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ],
                    ) 
                  ),
                ],
              )
            ],
          );
        }); 
      },
    );
    if (konfirmasi == true) {
      await deleteProduk(widget.produk!.id);
      Navigator.pop(context, true);
    }
  }
}