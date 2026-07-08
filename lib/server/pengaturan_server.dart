import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pnbfoods/common/tombol.dart';
import 'package:pnbfoods/common/top_bar.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/services/base_url.dart';

class PengaturanServer extends StatefulWidget {
  const PengaturanServer({super.key});

  @override
  State<PengaturanServer> createState() => _PengaturanServerState();
}

class _PengaturanServerState extends State<PengaturanServer> {
  final TextEditingController _customController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setInitialCustomText();
  }

  void _setInitialCustomText() {
    final current = BaseUrl.baseUrl;
    if (current != GetUrl.localhost && current != GetUrl.emulator) {
      _customController.text = current;
    }
  }

  Future<void> _setUrl(String url) async {
    await BaseUrl.setBaseUrl(url);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Server URL diubah ke $url'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _saveCustomUrl() async {
    final url = _customController.text.trim();
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan URL server'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    await _setUrl(url);
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = BaseUrl.baseUrl;

    return Scaffold(
      appBar: TopBar(title: "IP Address Server", icon: Icons.lan_outlined,),
      backgroundColor: Warna.warnaBackground,
      body: Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            _buildOption(
              title: 'Localhost',
              subtitle: GetUrl.localhost,
              selected: current == GetUrl.localhost,
              onTap: () {
                setState(() {
                  _setUrl(GetUrl.localhost);
                });
              },
            ),
            _buildOption(
              title: 'Emulator',
              subtitle: GetUrl.emulator,
              selected: current == GetUrl.emulator,
              onTap: () {
                setState(() {
                  _setUrl(GetUrl.emulator);
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _customController,
                      decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lan_outlined),
                      prefixIconColor: Warna.warnaAccent,
                      labelStyle: TextStyle(fontSize: 16),
                      filled: true,
                      fillColor: Warna.warnaBackground,
                      floatingLabelStyle: TextStyle(color: Warna.warnaTextGray, fontSize: 16),
                      hint: Text("http://192.168.1.12/api/"),
                      labelText: "Custom IP",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TombolNavigasi(
                    function: () => setState(() {_saveCustomUrl();}) , 
                    backgroundColor: Warna.warnaAccent, 
                    foregroundColor: Colors.white, text: "Simpan",
                    icon: Icons.save_outlined,
                  ),
                ],
              ),
            ),
            Wrap(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(16, 8, 5, 0),
                  child: TombolNavigasi(
                  function: () {
                    _customController.text = "http://192.168.x.x/api/";
                  }, 
                  backgroundColor: Warna.warnaBackground, 
                  foregroundColor: Warna.warnaAccent, 
                  text: "Format Alamat",
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(16, 8, 5, 0),
                  child: TombolNavigasi(
                  function: () {
                    _customController.text = "";
                  }, 
                  backgroundColor: Warna.warnaBackground, 
                  foregroundColor: Warna.warnaAccent, 
                  text: "Hapus",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      )
      
    );
  }

  Widget _buildOption({
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: selected ? Warna.warnaAccent : null,
      ),
      onTap: onTap,
    );
  }
}
