import 'package:flutter/material.dart';
import 'package:pnbfoods/common/tombol.dart';
import 'package:pnbfoods/common/top_bar.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/common/forms.dart';
import 'package:pnbfoods/models/pelanggan.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:pnbfoods/models/penjual.dart';
import 'package:pnbfoods/services/pelanggan_service.dart';
import 'package:pnbfoods/services/penjual_service.dart';

class EditProfile extends StatefulWidget {
  final Pelanggan? pelanggan;
  final Penjual? penjual;

  const EditProfile({super.key, this.pelanggan, this.penjual});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late final TextEditingController _namaPelanggan;
  late final TextEditingController _nim;
  late final TextEditingController _namaPenjual;
  late final TextEditingController _emailPenjual;
  File? _fotoProfil;
  bool _fotoProfileDihapus = false;

  @override
  void initState() {
    super.initState();
    if (widget.pelanggan != null) {
      _namaPelanggan = TextEditingController(text: widget.pelanggan!.namaPelanggan);
      _nim = TextEditingController(text: widget.pelanggan!.nim);
      _namaPenjual = TextEditingController();
      _emailPenjual = TextEditingController();
    } else {
      _namaPenjual = TextEditingController(text: widget.penjual!.namaPenjual);
      _emailPenjual = TextEditingController(text: widget.penjual!.email);
      _namaPelanggan = TextEditingController();
      _nim = TextEditingController();
    }
  }

  @override
  void dispose() {
    _namaPelanggan.dispose();
    _nim.dispose();
    _namaPenjual.dispose();
    _emailPenjual.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: "Edit Profil", icon: Icons.person_outline,),
      backgroundColor: Warna.warnaBackground,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 35),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: 139,
                      height: 139,
                      color: Color(0xFFD8BED0),
                      child: _fotoProfil != null
                        ? Image.file(
                            _fotoProfil!,
                            fit: BoxFit.cover,
                          )
                        : (!_fotoProfileDihapus && (widget.pelanggan?.fotoUrl != null || widget.penjual?.fotoUrl != null))
                            ? Image.network(
                                widget.pelanggan?.fotoUrl ?? widget.penjual?.fotoUrl ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person,
                                    size: 80,
                                    color: Colors.white,
                                  );
                                },
                              )
                            : const Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.white,
                              ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TombolNavigasi(function: () => _pickImage(), backgroundColor: Colors.white, foregroundColor: Colors.black, text: "Ganti"),
                      SizedBox(width: 20),
                      TombolNavigasi(function: () => _confirmDeleteProfile(context), backgroundColor: Colors.white, foregroundColor: Colors.red, text: "Hapus"),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("Ukuran gambar maksimal 5MB.",
                    style: TextStyle(fontSize: 10, color: Warna.warnaTextGray, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(20),
              child: Text("Identitas Pengguna", 
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 16.0),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  CustomTextFieldProfile(
                    controller: widget.pelanggan != null ? _namaPelanggan : _namaPenjual,
                    hintText: widget.pelanggan != null ? "Nama Lengkap" : "Nama Penjual",
                    icon: Icons.person_outline,
                  ),
                  SizedBox(height: 10),
                  CustomTextFieldProfile(
                    controller: widget.pelanggan != null ? _nim : _emailPenjual,
                    hintText: widget.pelanggan != null ? "NIM" : "Email",
                    icon: widget.pelanggan != null 
                      ? Icons.phone_android_outlined 
                      : Icons.email_outlined,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  TombolNavigasi(function: () {Navigator.pop(context);}, backgroundColor: Colors.white, foregroundColor: Colors.black, text: "Kembali"),
                  Spacer(),
                  TombolNavigasi(
                    function: () => _showSaveConfirmationDialog(context),
                    backgroundColor: Warna.warnaAccent, 
                    foregroundColor: Colors.white,
                    icon: Icons.check, 
                    text: "Simpan"),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }

  Future<void> _showSaveConfirmationDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Konfirmasi Simpan', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 16.0)),
          content: Text('Apakah Anda yakin ingin menyimpan perubahan identitas pengguna?', style: TextStyle(fontSize: 14, color: Colors.black87)),
          actions: <Widget>[
            Row(
              children: [
                TextButton(
                  child: Text('Batal', style: TextStyle(color: Colors.black87)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Spacer(),
                TextButton(
                  child: Text('Simpan', style: TextStyle(color: Colors.green)),
                  onPressed: () {   
                    Navigator.of(context).pop();            
                    _saveProfile();
                  },
                ),  
              ],
            )
          ],
        );
      },
    );
  }

  Future<void> _confirmDeleteProfile(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 16.0)),
          content: Text('Apakah Anda yakin ingin menghapus foto profil?', style: TextStyle(fontSize: 14, color: Colors.black87)),
          actions: <Widget>[
            TextButton(
              child: Text('Batal', style: TextStyle(color: Colors.black87)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () {
                _deletePhoto();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  
  void _saveProfile() async {
    try {
      if (widget.pelanggan != null) {
      await updatePelanggan(
        idPelanggan: widget.pelanggan!.idPelanggan,
        namaPelanggan: _namaPelanggan.text,
        nim: _nim.text,
        fotoProfile: _fotoProfil,
        hapusFoto: _fotoProfileDihapus,
      );
    } else {
      await updatePenjual(
        idPenjual: widget.penjual!.idPenjual,
        namaPenjual: _namaPenjual.text,
        email: _emailPenjual.text,          
        fotoProfile: _fotoProfil,
        hapusFoto: _fotoProfileDihapus,
      );
    }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil berhasil diperbarui!'), backgroundColor: Colors.green,),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal melakukan perubahan'), backgroundColor: Colors.red,),
      );
    }
  }

  void _deletePhoto() {
    setState(() {
      _fotoProfil = null;       
      _fotoProfileDihapus = true;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? gambar = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (gambar != null) {
      setState(() {
        _fotoProfil = File(gambar.path);
      });
    }
  }
}