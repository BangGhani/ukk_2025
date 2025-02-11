import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../../components/themes.dart';
import '../../logic/controller.dart';
import 'login.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final AuthController authController = AuthController();
  late Future<Map<String, dynamic>> profilData;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    profilData = authController.fetchProfile();
  }

  // Fungsi untuk mengubah string menjadi CamelCase
  String toCamelCase(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ThemeColor.background,
        elevation: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
          decoration: BoxDecoration(
            color: ThemeColor.putih,
            borderRadius: ThemeSize.borderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: const Text(
            "Profil",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: profilData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Tidak ada data profil'));
          }
          final profile = snapshot.data!;
          final String nama = profile['nama'] ?? '';
          final String email = profile['email'] ?? '';
          final String role = toCamelCase(profile['role'] ?? '');
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    nama,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        email,
                        style: const TextStyle(color: Colors.green),
                      ),
                      Text(
                        role,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Pengaturan akun',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: const Text('Ubah Password'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Implementasi aksi ubah password
                  },
                ),
                ListTile(
                  title: const Text('Edit Profil'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Implementasi aksi edit profil
                  },
                ),
                const Spacer(),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await authController.logout();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: ThemeColor.background,
                            content: AwesomeSnackbarContent(
                              title: 'Berhasil',
                              message: 'Logout Berhasil',
                              contentType: ContentType.success,
                            ),
                          ),
                        );
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gagal logout: $e')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Log Out'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
