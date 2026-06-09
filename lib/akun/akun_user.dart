import 'package:flutter/material.dart';
import 'package:pnbfoods/akun/ubah_password.dart';
import 'package:pnbfoods/auth/role_page.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/akun/edit_user.dart';
import 'package:pnbfoods/models/pelanggan.dart';
import 'package:pnbfoods/services/pelanggan_service.dart';
import 'package:pnbfoods/models/penjual.dart';
import 'package:pnbfoods/services/penjual_service.dart';

class ProfileUser extends StatefulWidget {
  final int userId;
  final String role;

  const ProfileUser({
    super.key, 
    required this.userId, 
    required this.role,
  });
  
  @override
  _ProfilUserState createState() => _ProfilUserState();
}

class _ProfilUserState extends State<ProfileUser> {

  Future<Pelanggan>? futurePelanggan;
  Future<Penjual>? futurePenjual;

  @override
  void initState() {
    super.initState();
    if (widget.role == 'pelanggan') {
      futurePelanggan= fetchPelanggan(widget.userId);
    } else {
      futurePenjual= fetchPenjual(widget.userId);
    }
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Warna.warnaBackground,
    body: widget.role == 'pelanggan'
        ? _buildViewPelanggan()
        : _buildViewPenjual(),
    );
  }


  Widget _buildViewPelanggan(){
    return FutureBuilder<Pelanggan>(
      future: futurePelanggan, 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData) {
         final pelanggan = snapshot.data!;
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [ 
                  Container(              
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xFFF9803B),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25)
                      ),
                    ),
                    child: 
                      Padding(padding: EdgeInsetsGeometry.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor:Color(0xFFD8BED0),
                            backgroundImage: pelanggan.fotoProfile != null
                              ? NetworkImage(pelanggan.fotoUrl!)
                              : null,
                          
                            child: pelanggan.fotoProfile == null
                              ? Icon( Icons.person, size: 40, color: Colors.white)
                              : null
                          ),
                          SizedBox(width: 5),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [ 
                              Text(pelanggan.namaPelanggan,
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16.0),
                              ),
                              Text(pelanggan.nim,
                                style: TextStyle(fontWeight: FontWeight.w200, color: Colors.white, fontSize: 10.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                      GestureDetector(
                          onTap: () => _openEditProfilePelanggan(context, pelanggan),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.manage_accounts_outlined),
                                SizedBox(width: 10),
                                Text("Edit Profile",
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => _openChangePasswordPelanggan(context, pelanggan),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.lock_outline),
                                SizedBox(width: 10),
                                Text("Ubah Password",
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            _openRiwayat(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.history_outlined),
                                SizedBox(width: 10),
                                Text("Riwayat",
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 250),
                        GestureDetector(
                          onTap: () {
                            _showLogoutConfirmationDialog(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.logout_outlined, color: Colors.red),
                                SizedBox(width: 10),
                                Text("Logout",
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return SizedBox();
      });
  }

  Widget _buildViewPenjual(){
    return FutureBuilder<Penjual>(
      future: futurePenjual, 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData) {
         final penjual = snapshot.data!;
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [ 
                  Container(              
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xFFF9803B),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25)
                      ),
                    ),
                    child: 
                      Padding(padding: EdgeInsetsGeometry.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor:Color(0xFFD8BED0),
                            backgroundImage: penjual.fotoProfile != null
                              ? NetworkImage(penjual.fotoUrl!)
                              : null,
                          
                            child: penjual.fotoProfile == null
                              ? Icon( Icons.person, size: 40, color: Colors.white)
                              : null
                          ),
                          SizedBox(width: 5),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [ 
                              Text(penjual.namaPenjual,
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16.0),
                              ),
                              Text(penjual.email,
                                style: TextStyle(fontWeight: FontWeight.w200, color: Colors.white, fontSize: 10.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                      GestureDetector(
                          onTap: () => _openEditProfilePenjual(context, penjual),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.manage_accounts_outlined),
                                SizedBox(width: 10),
                                Text("Edit Profile",
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => _openChangePasswordPenjual(context, penjual),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.lock_outline),
                                SizedBox(width: 10),
                                Text("Ubah Password",
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            _openRiwayat(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.history_outlined),
                                SizedBox(width: 10),
                                Text("Riwayat",
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 250),
                        GestureDetector(
                          onTap: () {
                            _showLogoutConfirmationDialog(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.logout_outlined, color: Colors.red),
                                SizedBox(width: 10),
                                Text("Logout",
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return SizedBox();
      });
  }

  Future<void> _openRiwayat(BuildContext context) async {
    //buka halaman riwayat pembelian
  }

  Future<void> _openChangePasswordPelanggan(BuildContext context, Pelanggan pelanggan) async {
    final result = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => UbahPassword(pelanggan: pelanggan))
    );
    if (result == true) {
      setState(() {
        futurePelanggan = fetchPelanggan(pelanggan.idPelanggan);
      });
    }
  }

  Future<void> _openChangePasswordPenjual(BuildContext context, Penjual penjual) async {
    final result = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => UbahPassword(penjual: penjual))
    );
    if (result == true) {
      setState(() {
        futurePenjual = fetchPenjual(penjual.idPenjual);
      });
    }
  }

  Future<void> _openEditProfilePelanggan(BuildContext context, Pelanggan pelanggan) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfile(pelanggan: pelanggan)),
    );
    if (result == true) {
      setState(() {
        futurePelanggan = fetchPelanggan(pelanggan.idPelanggan);
      });
    }
  }

  Future<void> _openEditProfilePenjual(BuildContext context, Penjual penjual) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfile(penjual: penjual)),
    );
    if (result == true) {
      setState(() {
        futurePenjual = fetchPenjual(penjual.idPenjual);
      });
    }
  }

  
  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 16.0)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apakah Anda yakin ingin logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal', style: TextStyle(color: Colors.black87)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                _logout(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async{
    try {
      if (widget.role == 'pelanggan') {
        await logoutPelanggan();
      } else {
        await logoutPenjual();
      }
    } catch (e) {
      // tetap lanjut logout walopun request gagal
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => PilihRole()),
      (route) => false,
    );
  }
}