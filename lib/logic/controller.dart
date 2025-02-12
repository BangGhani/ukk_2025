import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
export 'validator.dart';

final SupabaseClient supabase = Supabase.instance.client;

// Ubah deklarasi menjadi String? agar bisa null
String? usernameProfile;
late Map<String, dynamic> userData;

// Fungsi untuk menyimpan username ke SharedPreferences
Future<void> saveUsername(String username) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('usernameProfile', username);
}

// Fungsi untuk mengambil username dari SharedPreferences
Future<String?> loadUsername() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('usernameProfile');
}

Future<Map<String, dynamic>?> loadProfileFromStorage() async {
  final prefs = await SharedPreferences.getInstance();
  final profileString = prefs.getString('profile');
  if (profileString != null) {
    return jsonDecode(profileString) as Map<String, dynamic>;
  }
  return null;
}

class AuthController {
  Future<void> login(String username, String password) async {
    // Set dan simpan usernameProfile
    usernameProfile = username;
    await saveUsername(username);

    final userResponse =
        await supabase.from('user').select().eq('nama', username).maybeSingle();
    debugPrint('Login dengan Response user: $userResponse');
    if (userResponse == null) {
      debugPrint('Username $username tidak ditemukan');
      return;
    }

    final email = userResponse['email'];
    debugPrint('Email ditemukan: $email');

    final loginResponse = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    try {
      await supabase.auth.signOut();
      usernameProfile = null;
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('usernameProfile');
    } catch (e) {
      throw Exception('Gagal logout: $e');
    }
  }

  Future<Map<String, dynamic>> fetchProfile() async {
    String? usernameToUse = usernameProfile;
    if (usernameToUse == null) {
      usernameToUse = await loadUsername();
      if (usernameToUse == null) {
        throw Exception('Username belum diinisialisasi');
      }
      usernameProfile = usernameToUse;
    }

    final response = await supabase
        .from('user')
        .select('nama, email, role, id')
        .eq('nama', usernameToUse)
        .maybeSingle();
    if (response == null) {
      throw Exception('Gagal mengambil data profil');
    }
    userData = response;
    return response;
  }

  Future<void> saveProfile(Map<String, dynamic> profile) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('profile', jsonEncode(profile));
  }
}

class ProdukController {
  Future<List<dynamic>> fetchProduk() async {
    final response = await supabase.from('produk').select();
    if (response == null) {
      throw Exception('Gagal mengambil produk: $response');
    }
    return response;
  }

  Future<void> createProduk(Map<String, dynamic> produkData) async {
    final response = await supabase.from('produk').insert(produkData);
    if (response == null) {
      throw Exception('Gagal menambahkan produk: $response');
    }
  }

  Future<void> updateProduk(
      int produkID, Map<String, dynamic> produkData) async {
    final response = await supabase
        .from('produk')
        .update(produkData)
        .eq('produkID', produkID);
    if (response == null) {
      throw Exception('Gagal memperbarui produk: $response');
    }
  }

  Future<void> deleteProduk(int produkID) async {
    final response =
        await supabase.from('produk').delete().eq('produkID', produkID);
    if (response == null) {
      throw Exception('Gagal menghapus produk: $response');
    }
  }
}

class PelangganController {
  Future<List<dynamic>> fetchPelanggan() async {
    final response = await supabase.from('pelanggan').select();
    if (response == null) {
      throw Exception('Gagal mengambil pelanggan: $response');
    }
    return response;
  }

  Future<void> createPelanggan(Map<String, dynamic> pelangganData) async {
    final response = await supabase.from('pelanggan').insert(pelangganData);
    if (response == null) {
      throw Exception('Gagal menambahkan pelanggan: $response');
    }
  }

  Future<void> updatePelanggan(
      int pelangganID, Map<String, dynamic> pelangganData) async {
    final response = await supabase
        .from('pelanggan')
        .update(pelangganData)
        .eq('pelangganID', pelangganID);
    if (response == null) {
      throw Exception('Gagal memperbarui pelanggan: $response');
    }
  }

  Future<void> deletePelanggan(int pelangganID) async {
    final response = await supabase
        .from('pelanggan')
        .delete()
        .eq('pelangganID', pelangganID);
    if (response == null) {
      throw Exception('Gagal menghapus pelanggan: $response');
    }
  }
}

class TransaksiController {
  Future<void> addTransaction({
    required pelangganID,
    required int totalHarga, // Ini adalah total harga dasar dari cartItems
    required List<Map<String, dynamic>> cartItems,
    // Parameter tambahan untuk biaya dan diskon:
    required Map<String, bool> biayaOptions,
    required Map<String, bool> diskonOptions,
    required String?
        biayaLainnyaInput, // Nilai input dari user untuk opsi "Lainnya" pada biaya
  }) async {
    try {
      // --- Hitung biaya tambahan ---
      int additionalCost = 0;
      Map<String, dynamic> biayaLainJson = {};

      // Jika "Layanan" dipilih, tambahkan 2000
      if (biayaOptions["Layanan"] == true) {
        additionalCost += 2000;
        biayaLainJson["Layanan"] = true;
      } else {
        biayaLainJson["Layanan"] = false;
      }

      // Jika "Lainnya" dipilih, tambahkan nilai input (pastikan input valid sebagai angka)
      if (biayaOptions["Lainnya"] == true) {
        int nilaiLain = int.tryParse(biayaLainnyaInput ?? "") ?? 0;
        additionalCost += nilaiLain;
        biayaLainJson["Lainnya"] = nilaiLain;
      } else {
        biayaLainJson["Lainnya"] = 0;
      }

      // Untuk opsi "PPN" (jika dipilih), simpan saja boolean-nya.
      bool ppnSelected = (biayaOptions["PPN"] == true);
      biayaLainJson["PPN"] = ppnSelected;

      // --- Hitung subtotal awal ---
      int baseTotal = totalHarga; // Total dari cartItems
      int intermediateTotal = baseTotal + additionalCost;

      // --- Hitung diskon ---
      // Misalnya, untuk setiap diskon yang dipilih, total dikalikan dengan 0.7 (diskon 30% secara multiplikatif)
      int discountCount = diskonOptions.values.where((v) => v).length;
      double discountedTotal = intermediateTotal * pow(0.7, discountCount).toDouble();

      // --- Terapkan PPN jika dipilih ---
      double finalTotal =
          ppnSelected ? discountedTotal * 1.11 : discountedTotal;

      // Bulatkan hasil akhir ke integer
      int computedTotalHarga = finalTotal.round();

      // Insert data ke tabel penjualan
      final penjualanResponse = await supabase.from('penjualan').insert({
        'totalharga': computedTotalHarga,
        'pelangganID': pelangganID,
        'diskon': diskonOptions, // Disimpan sebagai JSON
        'biaya_lain': biayaLainJson, // Disimpan sebagai JSON
      }).select();

      final penjualanID = penjualanResponse[0]['penjualanID'];

      // Siapkan data untuk detail penjualan
      final List<Map<String, dynamic>> detailPenjualan = cartItems.map((item) {
        return {
          'penjualanID': penjualanID,
          'produkID': item['produkID'],
          'jumlahproduk': item['total'],
          'subtotal': (item['harga'] as int) * (item['total'] as int),
        };
      }).toList();

      await supabase.from('detailpenjualan').insert(detailPenjualan);

      // Update stok untuk setiap produk
      for (var item in cartItems) {
        final produkResponse = await supabase
            .from('produk')
            .select('stok')
            .eq('produkID', item['produkID'])
            .maybeSingle();

        if (produkResponse != null && produkResponse['stok'] != null) {
          final currentStok = produkResponse['stok'] as int;
          final jumlahTerjual = item['total'] as int;
          final newStok = currentStok - jumlahTerjual;
          await supabase
              .from('produk')
              .update({'stok': newStok}).eq('produkID', item['produkID']);
        }
      }

      debugPrint('Transaksi berhasil');
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchPenjualan() async {
    try {
      if (userData.containsKey('id')) {
        final response = await supabase
            .from('penjualan')
            .select('*, pelanggan:pelangganID(*)')
            .eq('pelanggan.userID', userData['id'])
            .order('tanggalpenjualan', ascending: false);
        return response as List<dynamic>;
      } else {
        final response = await supabase
            .from('penjualan')
            .select('*, pelanggan:pelangganID(*)')
            .order('tanggalpenjualan', ascending: false);
        return response as List<dynamic>;
      }
    } catch (e) {
      debugPrint('Error fetching penjualan: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchDetailPenjualan(int penjualanID) async {
    try {
      final response = await supabase
          .from('detailpenjualan')
          .select('*, produk(*)')
          .eq('penjualanID', penjualanID);
      return response as List<dynamic>;
    } catch (e) {
      debugPrint('Error fetching detail penjualan: $e');
      rethrow;
    }
  }

  Future<String> fetchCustomerName(dynamic pelangganID) async {
    try {
      final response = await supabase
          .from('pelanggan')
          .select('namapelanggan')
          .eq('pelangganID', pelangganID)
          .maybeSingle();
      if (response != null && response['namapelanggan'] != null) {
        return response['namapelanggan'].toString();
      } else {
        return 'Non Member';
      }
    } catch (e) {
      debugPrint('Error fetching customer name: $e');
      return 'Non Member';
    }
  }
}
