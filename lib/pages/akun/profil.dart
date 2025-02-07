import 'package:flutter/material.dart';
import '../../components/themes.dart';

class Profil extends StatelessWidget {
  const Profil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.background,
      body: Column(
        children: [
          Container(
            color: ThemeColor.hijau,
            padding: EdgeInsets.all(ThemeSize.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profil',
                  style: TextStyle(
                    color: ThemeColor.putih,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Nama: BangGhani',
                  style: TextStyle(color: ThemeColor.putih, fontSize: 18),
                ),
                Text(
                  'Role: Admin',
                  style: TextStyle(color: ThemeColor.putih, fontSize: 18),
                ),
                Text(
                  'Email: ajsnff@gmail.com',
                  style: TextStyle(color: ThemeColor.putih, fontSize: 18),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColor.hitam,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: ThemeColor.background,
              child: Center(
                child: Text('Ini Halaman Profil'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
