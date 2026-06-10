import 'package:flutter/material.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/models/produk.dart';

class DeskripsiMakanan extends StatefulWidget {
  final Produk produk;

  const DeskripsiMakanan({super.key, required this.produk});

  @override
  State<DeskripsiMakanan> createState() => _DeskripsiMakananState();
}

class _DeskripsiMakananState extends State<DeskripsiMakanan> {
  int _count = 1;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage("assets/img/nasi.jpg"),
                ),
              ),
            ),

            SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.produk.namaProduk,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                  widget.produk.hargaProduk.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Warna.warnaAccent,
                  ),
                ),
              ],
            ),

            SizedBox(height: 8),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: Warna.warnaAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "89+ terjual",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),

            SizedBox(height: 20),

            Text(
              "Deskripsi:",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
            ),

            Text(
              widget.produk.deskripsiProduk!,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10),
            ),

            SizedBox(height: 15),

            Text(
              "Tambah catatan untuk pembelian",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),

            SizedBox(height: 8),

            TextField(
              controller: _noteController,
              style: TextStyle(fontSize: 10, color: Colors.black),
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Contoh: Ekstra pedas ya cabe 9",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Warna.warnaAccent),
                ),
              ),
            ),
            SizedBox(height: 15),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_border,
                  size: 14,
                  color: Colors.grey,
                ),
                label: Text(
                  "Favorit",
                  style: TextStyle(fontSize: 10, color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (_count > 1) {
                      setState(() => _count--);
                    }
                  },
                  icon: Icon(Icons.remove, color: Colors.black),
                ),

                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Warna.warnaAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "$_count",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    setState(() => _count++);
                  },
                  icon: Icon(Icons.add, color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'quantity': _count,
                    'note': _noteController.text,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Warna.warnaAccent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Tambah Pembelian",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
