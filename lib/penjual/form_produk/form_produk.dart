import 'package:flutter/material.dart';
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
                  TextButton(
                    onPressed: () {}, 
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      overlayColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10)
                      )
                    ),
                    child: Text("Upload gambar",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400
                      ),
                    ),
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
                        TextFormField(
                          controller: nama,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.edit),
                            prefixIconColor: Warna.warnaAccent,
                            labelStyle: TextStyle(fontSize: 16),
                            filled: true,
                            fillColor: Colors.white,
                            floatingLabelStyle: TextStyle(
                              color: Warna.warnaTextGray,
                              fontSize: 16,
                            ),
                            labelText: 'Nama Menu',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none
                            )
                          ),
                        ),
                        TextFormField(
                          controller: harga,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsetsGeometry.only(top: 13, left: 12),
                              child: Text("Rp.",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Warna.warnaAccent
                                ),),
                            ),
                            labelStyle: TextStyle(fontSize: 16),
                            filled: true,
                            fillColor: Colors.white,
                            floatingLabelStyle: TextStyle(
                              color: Warna.warnaTextGray,
                              fontSize: 16,
                            ),
                            labelText: 'Harga',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none
                            )
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsetsGeometry.only(top: 15, left: 15),
                                child: Row(
                                  children: [
                                    Icon(Icons.description_outlined,
                                      size: 20,
                                    ),
                                    SizedBox(width: 5,),
                                    Text("Deskripsi")
                                  ],
                                ),
                              ),
                              TextFormField(
                                controller: deskripsi,
                                minLines: 5,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(fontSize: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Warna.warnaTextGray
                                    )
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none
                                  )
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: false, 
                                        onChanged: (bool) {

                                        }
                                      ),
                                      Text("Stok")
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {}, 
                                        icon: Icon(Icons.remove)
                                      ),
                                      SizedBox(
                                        width: 35,
                                        height: 35,
                                        child: TextFormField(
                                          controller: stok,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          minLines: 1,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white
                                          ),
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.symmetric(vertical: 5),
                                            filled: true,
                                            fillColor: Warna.warnaAccent,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: BorderSide.none
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: BorderSide.none
                                            )
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {}, 
                                        icon: Icon(Icons.add)
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
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