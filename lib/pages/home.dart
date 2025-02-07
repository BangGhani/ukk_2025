import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../components/themes.dart';

import 'produk/produk.dart';
import 'transaksi/transaksi.dart';
import 'akun/profil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  List<Widget> pages = [
    Produk(),
    Transaksi(),
    Profil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: ThemeColor.background,
        color: ThemeColor.hijau,
        items: <Widget>[
          Icon(Icons.list, size: 30, color: ThemeColor.putih),//produk
          Icon(Icons.compare_arrows, size: 30, color: ThemeColor.putih),//transaksi
          Icon(Icons.person, size: 30, color: ThemeColor.putih),//profil
        ],
        onTap: (index) {
          setState(() {
            selectedIndex = index; 
          });
        },
      ),
    );
  }
}
