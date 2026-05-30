import 'package:flutter/material.dart';
import 'package:pnbfoods/common/forms.dart';
import 'package:pnbfoods/common/tombol.dart';
import 'package:pnbfoods/common/top_bar.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/database/database.dart';
import 'package:pnbfoods/main.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: "Tambah Menu"),
      backgroundColor: Warna.warnaBackground,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white
                    ),
                    child: Icon(Icons.image_not_supported, 
                      color: Warna.warnaTextGray,
                      size: 60,
                    ),
                  ),
                  SizedBox(height: 10,),
                  TombolNavigasi(
                    function: () {}, 
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black, 
                    text: "Upload gambar"
                  ),
                  Text("Ukuran gambar maksimal 5MB",
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
                      Text("Menu",
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
                          labelText: "Nama Menu", 
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
                          minLines: 5, 
                          maxLines: 5, 
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
    if (widget.produk == null) {
      await database
      .into(database.produk)
      .insert(ProdukCompanion.insert(
        deskripsiProduk: deskripsi!.text,
        fotoProduk: "",
        hargaProduk: harga!.text,
        kategoriProduk: "",
        namaProduk: nama!.text,
        stok: stok!.text,
      ));
      Navigator.pop(context);
    }
  }
}