import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../components/themes.dart';
import '../logic/controller.dart';

import 'produk/produk.dart';
import 'transaksi/transaksi.dart';
import 'transaksi/invoice.dart';
import 'akun/profil.dart';
import 'pelanggan/pelanggan.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController authController = AuthController();
  Map<String, dynamic>? profile;

  // Variabel untuk menentukan halaman dan index berdasarkan role
  int selectedIndex = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final fetchedProfile = await authController.fetchProfile();
      setState(() {
        profile = fetchedProfile;
      });

      final String role = fetchedProfile['role'] as String;

      if (role == 'pelanggan') {
        setState(() {
          selectedIndex = 0;
          pages = [
            Invoice(),
            Profil(),
          ];
        });
        debugPrint('User ${fetchedProfile['nama']} adalah pelanggan');
      } else if (role == 'petugas') {
        setState(() {
          selectedIndex = 2;
          pages = [
            Produk(),
            Pelanggan(),
            Transaksi(),
            Invoice(),
            Profil(),
          ];
        });
        debugPrint('User ${fetchedProfile['nama']} adalah petugas');
      } else {
        setState(() {
          selectedIndex = 2;
          pages = [
            Produk(),
            Pelanggan(),
            Transaksi(),
            Invoice(),
            Profil(),
          ];
        });
        debugPrint('User ${fetchedProfile['nama']} memiliki role: $role');
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
  }

  // Fungsi untuk membangun item pada bottom navigation bar berdasarkan role
  List<Widget> _buildBottomNavigationItems() {
    final String role = profile?['role'] ?? '';
    if (role == 'pelanggan') {
      return [
        Icon(Icons.list_alt_outlined, size: 30, color: ThemeColor.putih),
        Icon(Icons.person_pin, size: 30, color: ThemeColor.putih),
      ];
    } else {
      return [
        Icon(Icons.list, size: 30, color: ThemeColor.putih), // produk
        Icon(Icons.people_alt_outlined,
            size: 30, color: ThemeColor.putih), // pelanggan
        Icon(Icons.compare_arrows,
            size: 30, color: ThemeColor.putih), // transaksi
        Icon(Icons.list_alt_outlined,
            size: 30, color: ThemeColor.putih), // invoice
        Icon(Icons.person_pin, size: 30, color: ThemeColor.putih), // profil
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Jika profil belum ter-load atau pages masih kosong, tampilkan progress indicator.
    if (profile == null || pages.isEmpty) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
        index: selectedIndex,
        items: _buildBottomNavigationItems(),
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
