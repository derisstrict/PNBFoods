import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pnbfoods/common/top_bar.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/models/kantin.dart';
import 'package:pnbfoods/models/produk.dart';
import 'package:pnbfoods/pembeli/deskripsi_makanan/deskripsi_makanan.dart';
import 'package:pnbfoods/pembeli/keranjang/page_keranjang.dart';
import 'package:pnbfoods/pembeli/list_produk/widget/card_produk.dart';
import 'package:pnbfoods/services/cart_service.dart';
import 'package:pnbfoods/services/produk_service.dart';

class ListProduk extends StatefulWidget {
  final Kantin kantin;

  const ListProduk({super.key, required this.kantin});

  @override
  State<ListProduk> createState() => _ListProdukState();
}

class _ListProdukState extends State<ListProduk> {
  String _filterMakanan = "";
  String _searchQuery = "";
  String? _searchHint;
  final _searchController = TextEditingController();
  late Future<List<Produk>> futureProduk;

  String formatRupiah(int nilai) {
    final formatted = nilai.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp. $formatted';
  }

  @override
  void initState() {
    super.initState();
    futureProduk = fetchProdukByPenjual(widget.kantin.idPenjual).then((list) {
      if (list.isNotEmpty) {
        final random = list[DateTime.now().millisecondsSinceEpoch % list.length];
        _searchHint = random.namaProduk;
        setState(() {});
      }
      return list;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBarless(),
      backgroundColor: Warna.warnaBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double screenPadding = 40.0;
            double finalWidth = (screenWidth - (screenPadding * 2)) / 2;
            return Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TopBarHeader(
                          width: double.infinity,
                          style: TopBarHeader.pembeli,
                          text1: widget.kantin.namaKantin,
                          text2: widget.kantin.kategori,
                          searchController: _searchController,
                          searchHint: _searchHint,
                          onSearchChanged: (value) {
                            setState(() => _searchQuery = value);
                          },
                          kantin: widget.kantin,
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text("Apa yang ingin kamu cari?",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _filterMakanan = "";
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: _filterMakanan == "" ? Warna.warnaAccent :Colors.white,
                                      foregroundColor: _filterMakanan == "" ? Colors.white :Colors.black
                                    ),
                                    child: Text("Semua",)
                                  ),
                                  SizedBox(width: 10),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _filterMakanan = "Makanan";
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: _filterMakanan == "Makanan" ? Warna.warnaAccent :Colors.white,
                                      foregroundColor: _filterMakanan == "Makanan" ? Colors.white :Colors.black
                                    ),
                                    child: Text("Makanan",)
                                  ),
                                  SizedBox(width: 10),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _filterMakanan = "Minuman";
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: _filterMakanan == "Minuman" ? Warna.warnaAccent :Colors.white,
                                      foregroundColor: _filterMakanan == "Minuman" ? Colors.white :Colors.black
                                    ),
                                    child: Text("Minuman")
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              FutureBuilder<List<Produk>>(
                                future: futureProduk,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  }
                                  if (!snapshot.hasData) {
                                    return Text("Belum terdapat produk pada kantin ini.");
                                  }

                                  if (snapshot.hasData) {
                                    final items = snapshot.data!;

                                    final filterItems = items.where((produk) {
                                      if (_filterMakanan != "" && produk.kategoriProduk != _filterMakanan) return false;
                                      if (_searchQuery.isNotEmpty && !produk.namaProduk.toLowerCase().contains(_searchQuery.toLowerCase())) return false;
                                      return true;
                                    }).toList();

                                    return MasonryGridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                      itemCount: filterItems.length,
                                      itemBuilder: (context, index) {
                                        final produk = filterItems[index];
                                        final qty = CartService().getQuantity(widget.kantin.id, produk.id);
                                        return CardProduk(
                                          produk: produk,
                                          appDir: "",
                                          width: finalWidth,
                                          isAccent: qty > 0,
                                          cartCount: qty,
                                          onTap: () async {
                                            final result = await showModalBottomSheet(
                                              context: context,
                                              showDragHandle: true,
                                              useSafeArea: true,
                                              barrierColor: Colors.black45,
                                              backgroundColor: Warna.warnaBackground,
                                              isScrollControlled: true,
                                              builder: (context) => DeskripsiMakanan(produk: produk),
                                            );
                                            if (result != null) {
                                              CartService().addOrUpdate(
                                                widget.kantin.id,
                                                produk.id,
                                                produk.namaProduk,
                                                produk.hargaProduk,
                                                produk.fotoUrl ?? '',
                                                qty + (result['quantity'] as int),
                                                catatan: result['note'] as String?,
                                              );
                                              setState(() {});
                                            }
                                          },
                                        );
                                      }
                                    );
                                  } else if (snapshot.hasError) {
                                      return Text('${snapshot.error}');
                                    }
                                  return const CircularProgressIndicator();
                                }
                              ),
                              SizedBox(height: 10),
                              Wrap(
                                spacing: 10.0,
                                runSpacing: 10.0,
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.start,
                                runAlignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.end,
                                children: [],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!CartService().isEmpty(kantinId: widget.kantin.id))
                  Positioned(
                    bottom: 20,
                    left: 15,
                    right: 15,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KeranjangPage(kantin: widget.kantin,),
                          ),
                        ).then((_) => setState(() {}));
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Warna.warnaAccent,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          spacing: 10,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                            ),
                            Text("${CartService().totalItems(kantinId: widget.kantin.id)} Item",
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                            Spacer(),
                            Text(formatRupiah(CartService().totalHarga(kantinId: widget.kantin.id)),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_up_rounded,
                              size: 24,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    )
                  )
              ],
            );
          }
        )
      ),
    );
  }
}
