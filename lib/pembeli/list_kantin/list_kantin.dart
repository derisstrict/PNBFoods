import 'package:flutter/material.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/models/kantin.dart';
import 'package:pnbfoods/models/pelanggan.dart';
import 'package:pnbfoods/pembeli/list_kantin/widget/card_kantin.dart';
import 'package:pnbfoods/pembeli/list_produk/list_produk.dart';
import 'package:pnbfoods/services/cart_service.dart';
import 'package:pnbfoods/services/kantin_service.dart';
import 'package:pnbfoods/services/pelanggan_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListKantin extends StatefulWidget {
  @override
  _ListKantinState createState() => _ListKantinState();
}

class _ListKantinState extends State<ListKantin> {
  late Future<List<Kantin>> futureKantin;
  Future<Pelanggan>? pelanggan;
  Pelanggan? pelangganData; // Untuk hint di search bar nantinya.

  int? idPelanggan;

    void getIdPengguna() async {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getInt('userId');
      setState(() {
        idPelanggan = id;
      });
      if (idPelanggan != null) {
        pelanggan = fetchPelanggan(idPelanggan!);
      }
  }

  @override
  void initState() {
    super.initState();
    getIdPengguna();    
    futureKantin = fetchSemuaKantin();
  }

  void refreshKantin() {
    setState(() {
      futureKantin = fetchSemuaKantin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.warnaBackground,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Color(0xFFF9803B),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello",
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 5),
                            FutureBuilder(
                              future: pelanggan, 
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Text('Loading...', style: TextStyle(color: Colors.white),);
                                }
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Column(
                                      spacing: 10,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Error: ${snapshot.error}'),
                                      ],
                                    ),
                                  );
                                }
                                if (snapshot.hasData) {
                                  pelangganData = snapshot.data;
                                  return Text(snapshot.data!.namaPelanggan,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  );
                                }
                                return Text('Loading...', style: TextStyle(color: Colors.white),);
                              }
                            )
                          ],
                        ),

                        Spacer(),

                        FutureBuilder(
                          future: pelanggan, 
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white24,
                                child: Icon(Icons.person, size: 32, color: Colors.white,),
                              ); 
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Column(
                                  spacing: 10,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Error: ${snapshot.error}'),
                                  ],
                                ),
                              );
                            }
                            if (snapshot.hasData && snapshot.data!.fotoUrl != null) {
                              return CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  snapshot.data!.fotoUrl!,
                                ),
                              );
                            } 
                            return CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white24,
                              child: Icon(Icons.person, size: 32, color: Colors.white,),
                            ); 
                          }
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.only(
                      top: 5,
                      left: 10,
                      right: 10,
                      bottom: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search_outlined, color: Color(0xFFF9803B)),
                        SizedBox(width: 5),
                        Text(
                          "Kantin Ibu Gacor",
                          style: TextStyle(fontSize: 12, color: Colors.black38),
                        ),
                        Spacer(),
                        Icon(
                          Icons.store_mall_directory_rounded,
                          color: Warna.warnaAccent,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: 5),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFFF9803B),
                        foregroundColor: Colors.white,
                      ),
                      child: Text("Semua"),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      child: Text("Terlaris"),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      child: Text("Termurah"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Expanded(
            child: FutureBuilder<List<Kantin>>(
              future: futureKantin,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "Belum ada kantin.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      final kantin = snapshot.data![index];

                      return CardKantin(
                        namaKantin: kantin.namaKantin,
                        kategori: kantin.kategori,
                        infoHarga: "Lihat Menu",
                        imageUrl: kantin.fotoUrl ?? 'https://picsum.photos/200?id=${kantin.id}',
                        cartItemCount: CartService().totalItems(kantinId: kantin.id),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListProduk(kantin: kantin),
                            ),
                          );
                          setState(() {});
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF9803B)),
                  ),
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}
