import 'package:flutter/material.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final warna = Warna();
    return Scaffold(
      appBar: TopBar(title: "Tambah Menu"),
      backgroundColor: warna.warnaBackground,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    TextField(
                      controller: nama,
                      decoration: InputDecoration(
                        labelText: "Nama produk"
                      ),
                    ),
                    TextField(
                      controller: harga,
                      decoration: InputDecoration(
                        labelText: "Harga produk"
                      ),
                    ),
                    TextField(
                      controller: deskripsi,
                      decoration: InputDecoration(
                        labelText: "Deskripsi produk"
                      ),
                    ),
                    TextButton(
                      onPressed: upsertData, 
                      child: Text("Simpan"))
                  ],
                )
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
        stok: 5,
      ));
      Navigator.pop(context);
    }
  }
}