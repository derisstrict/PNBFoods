import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pnbfoods/common/forms.dart';
import 'package:pnbfoods/common/tombol.dart';
import 'package:pnbfoods/common/top_bar.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/database/database.dart';
import 'package:pnbfoods/main.dart';
import 'package:path/path.dart' as p;

class FormProduk extends StatefulWidget {
  final ProdukData? produk;

  const FormProduk({super.key, this.produk});

  @override
  State<FormProduk> createState() => _FormProdukState();
}

class _FormProdukState extends State<FormProduk> {

  TextEditingController? nama;
  TextEditingController? harga;
  TextEditingController? deskripsi;
  TextEditingController? stok;
  String? gambar;

  String? _appDirPath = "";

  Future<void> _initPath() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    setState(() {
      _appDirPath = appDir.path;
    });
  }

  @override
  void initState() {
    nama = TextEditingController(
      text: widget.produk == null ? "" : widget.produk!.namaProduk
    );
    harga = TextEditingController(
      text: widget.produk == null ? "" : widget.produk!.hargaProduk
    );
    deskripsi = TextEditingController(
      text: widget.produk == null ? "" : widget.produk!.deskripsiProduk
    );
    stok = TextEditingController(
      text: widget.produk == null ? "1" : widget.produk!.stok
    );
    gambar = widget.produk == null ? "" : widget.produk!.fotoProduk;
    super.initState();
    _initPath();
  }

  @override
  Widget build(BuildContext context) {
    File fileGambar = File(p.join(_appDirPath!, gambar)); 
    return Scaffold(
      appBar: TopBar(title: "Tambah Produk"),
      backgroundColor: Warna.warnaBackground,
      body: SafeArea(
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
                    child: gambar != "" ? Image.file(fileGambar, height: 80, width: 80, fit: BoxFit.cover,) : Icon(Icons.image_not_supported, 
                      color: Warna.warnaTextGray,
                      size: 60,
                    ),
                  ),
                  SizedBox(height: 10,),
                  TombolNavigasi(
                    function: () async {
                      String? ambilGambar = await saveImage();
                      setState(() {
                        gambar = ambilGambar;
                      });
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
                  Text(gambar!,
                   style: TextStyle(
                    fontSize: 10
                   ),
                  )
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
                        ),
                        TextArea(
                          controller: deskripsi!, 
                          minLines: 4, 
                          maxLines: 4, 
                          icon: Icons.description_outlined, 
                          title: "Deskripsi"
                        ),
                        Stok(
                          controller: stok!
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
        )
      ),
    );
  }

  Future<void> upsertData() async {
    if (nama!.text == '' || harga!.text == '' || gambar == '') {
      const snackbar = SnackBar(
        content: Text("Salah satu form belum terisi.")
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return;
    }
    if (widget.produk == null) {
      await database
      .into(database.produk)
      .insert(ProdukCompanion.insert(
        deskripsiProduk: deskripsi!.text,
        fotoProduk: gambar!,
        hargaProduk: harga!.text,
        kategoriProduk: "",
        namaProduk: nama!.text,
        stok: stok!.text,
      ));
      Navigator.pop(context);
    }
  }

  Future<String?> saveImage() async {
    final ImagePicker picker = ImagePicker();
    final Directory appDir = await getApplicationDocumentsDirectory();
    
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile == null) return "";

    String fileName = "img_${DateTime.now().millisecondsSinceEpoch}${p.extension(pickedFile.path)}";
    String permanentPath = p.join(appDir.path, fileName);
    await File(pickedFile.path).copy(permanentPath);
    
    return fileName; 
  }
}