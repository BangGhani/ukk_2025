import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ukk_2025/pages/transaksi/invoice.dart';
import '../components/themes.dart';

import 'produk/produk.dart';
import 'transaksi/transaksi.dart';
import 'akun/profil.dart';
import 'pelanggan/pelanggan.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  List<Widget> pages = [
    Produk(),
    Pelanggan(),
    Transaksi(),
    Invoice(),
    Profil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), 
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: AppBar(
            backgroundColor: ThemeColor.background,
            elevation: 0,
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                height: 200,
              ),
            ),
          ),
        ),
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: ThemeColor.background,
        color: ThemeColor.hijau,
        items: <Widget>[
          Icon(Icons.list, size: 30, color: ThemeColor.putih), // produk
          Icon(Icons.people_alt_outlined, size: 30, color: ThemeColor.putih), // pelanggan
          Icon(Icons.compare_arrows, size: 30, color: ThemeColor.putih), // transaksi
          Icon(Icons.list_alt_outlined, size: 30, color: ThemeColor.putih), // invoice
          Icon(Icons.person_pin, size: 30, color: ThemeColor.putih), // profil
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
