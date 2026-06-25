import 'package:flutter/material.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/models/produk.dart';
import 'package:timeago/timeago.dart';

class DeskripsiMakanan extends StatefulWidget {
  final Produk produk;

  const DeskripsiMakanan({super.key, required this.produk});

  @override
  State<DeskripsiMakanan> createState() => _DeskripsiMakananState();
}

class _DeskripsiMakananState extends State<DeskripsiMakanan> {
  int _count = 1;
  final _noteController = TextEditingController();

  String formatRupiah(int nilai) {
    final formatted = nilai.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp. $formatted';
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              width: double.infinity,
              // padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(10),
                      child: Container(
                        child: widget.produk.fotoProduk == "" || widget.produk.fotoProduk == null 
                        ? 
                        Icon(Icons.image_rounded, size: 160, color: Colors.white,) 
                        : 
                        Image.network(widget.produk.fotoUrl!, fit: BoxFit.cover, width: double.infinity, height: 220, cacheHeight: 400,),
                      ) 
                    ),
            ),

            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                children: [
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
                        formatRupiah(widget.produk.hargaProduk),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Warna.warnaAccent,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 3,
                    children: [
                      Icon(Icons.shopping_bag_outlined,
                        size: 16,
                        color: Colors.black,
                      ),
                      Text(
                        "89 terjual",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.favorite_border,
                          size: 22,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Deskripsi",
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14,),
                          ),

                          SizedBox(height: 4,),

                          Text(
                            widget.produk.deskripsiProduk!,
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  ),
                  
                  SizedBox(height: 15),

                  Row(
                    children: [
                      Icon(
                        Icons.edit_note
                      ),
                      Text(
                        "Tambah catatan untuk pembelian",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      )
                    ],
                  )
                  ,

                  SizedBox(height: 8),

                  TextField(
                    controller: _noteController,
                    style: TextStyle(fontSize: 10, color: Colors.black),
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Contoh: Ekstra pedas ya cabe 9",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black12
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Warna.warnaAccent),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            // Center(
            //   child: TextButton.icon(
            //     onPressed: () {},
            //     icon: Icon(
            //       Icons.favorite_border,
            //       size: 14,
            //       color: Colors.grey,
            //     ),
            //     label: Text(
            //       "Favorit",
            //       style: TextStyle(fontSize: 10, color: Colors.black),
            //     ),
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Warna.warnaBackground,
            //       elevation: 0,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                children: [
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

                      SizedBox(width: 25,),

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

                      SizedBox(width: 25,),

                      IconButton(
                        onPressed: () {
                          setState(() => _count++);
                        },
                        icon: Icon(Icons.add, color: Colors.black),
                      ),
                    ],
                  ),
                  
                ],
              ),
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
                      style: TextButton.styleFrom(
                        backgroundColor: Warna.warnaAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 5,
                        children: [
                          Icon(Icons.add_shopping_cart,
                            color: Colors.white,
                          ),
                          Text(
                            "Tambah ke Keranjang",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ) 
                    ),
                  ),
                  SizedBox(height: 25,)
          ],
        ),
      ),
    );
  }
}
