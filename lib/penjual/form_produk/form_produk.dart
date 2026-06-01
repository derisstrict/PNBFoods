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

  bool _nilaiCheckbox = false;
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
    // _gambar = widget.produk == null ? "" : widget.produk!.fotoProduk;
    super.initState();
    _initPath();
  }

  Widget _gambarKaloEdit() {
    if (widget.produk != null) {
      if (widget.produk!.fotoProduk != null) {
        return Image.network(widget.produk!.fotoUrl!, height: 80, width: 80, fit: BoxFit.cover,);
      } else {
        return Icon(Icons.image_not_supported, 
          color: Warna.warnaTextGray,
          size: 60,
        );
      }
    } else {
      return Text("");
    }
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
                          Visibility(
                            visible: widget.produk == null,
                            child: _gambar != null ? Image.file(_gambar!, height: 80, width: 80, fit: BoxFit.cover,) : Icon(Icons.image_not_supported, 
                              color: Warna.warnaTextGray,
                              size: 60,
                            ),
                          ),
                          Visibility(
                            visible: widget.produk != null,
                            child: _gambarKaloEdit()
                          )
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
                              padding: EdgeInsetsGeometry.only(top: 13, left: 12),
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
                            initialValue: "Makanan", 
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
                            checkboxValue: _nilaiCheckbox,
                            enabled: (value) {
                              setState(() {
                                _nilaiCheckbox = value;
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
                                  Navigator.pop(context);
                                }, 
                                backgroundColor: Colors.white, 
                                foregroundColor: Colors.black,
                                text: "Kembali",
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
    if (nama!.text == '' || harga!.text == '' || _gambar == null) {
      const snackbar = SnackBar(
        content: Text("Salah satu form belum terisi.")
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return;
    }
    if (widget.produk == null) {
      await postProduk(
        namaProduk: nama!.text, 
        deskripsiProduk: deskripsi!.text, 
        hargaProduk: int.parse(harga!.text), 
        kategoriProduk: _kategori!, 
        stok: int.parse(stok!.text), 
        fotoProduk: _gambar!
      );
      Navigator.pop(context);
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