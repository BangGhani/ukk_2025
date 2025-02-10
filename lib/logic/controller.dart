import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
export 'validator.dart';

final SupabaseClient supabase = Supabase.instance.client;

class AuthController {
  Future<void> login(String username, String password) async {
    final userResponse =
        await supabase.from('user').select().eq('nama', username).maybeSingle();
    debugPrint('Response user: $userResponse');

    if (userResponse == null) {
      debugPrint('Username tidak ditemukan');
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
    } catch (e) {
      throw Exception('Gagal logout: $e');
    }
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

// class TransaksiController {
//   Future<void> addTransaction({
//     required pelangganID,
//     required int totalHarga,
//     required List<Map<String, dynamic>> cartItems,
//   }) async {
//     try {
//       final penjualanResponse = await supabase.from('penjualan').insert({
//         'totalharga': totalHarga,
//         'pelangganID': pelangganID,
//       }).select();
//       final penjualanID = penjualanResponse[0]['penjualanID'];
//       final List<Map<String, dynamic>> detailPenjualan = cartItems.map((item) {
//         return {
//           'penjualanID': penjualanID,
//           'produkID': item['produkID'],
//           'jumlahproduk': item['total'],
//           'subtotal': (item['harga'] as int) * (item['total'] as int),
//         };
//       }).toList();
//       await supabase.from('detailpenjualan').insert(detailPenjualan);
//       debugPrint('Transaction successfully added!');
//     } catch (e) {
//       debugPrint('Error adding transaction: $e');
//       rethrow;
//     }
//   }
// }

class TransaksiController {
  Future<void> addTransaction({
    required pelangganID,
    required int totalHarga,
    required List<Map<String, dynamic>> cartItems,
  }) async {
    try {
      final penjualanResponse = await supabase.from('penjualan').insert({
        'totalharga': totalHarga,
        'pelangganID': pelangganID,
      }).select();

      final penjualanID = penjualanResponse[0]['penjualanID'];

      final List<Map<String, dynamic>> detailPenjualan = cartItems.map((item) {
        return {
          'penjualanID': penjualanID,
          'produkID': item['produkID'],
          'jumlahproduk': item['total'],
          'subtotal': (item['harga'] as int) * (item['total'] as int),
        };
      }).toList();

      await supabase.from('detailpenjualan').insert(detailPenjualan);

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
          // Perbarui stok produk di tabel produk
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
      final response = await supabase
          .from('penjualan')
          .select('*, pelanggan(*)')
          .order('tanggalpenjualan', ascending: false);
      return response as List<dynamic>;
    } catch (e) {
      debugPrint('Error fetching penjualan: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchDetailPenjualan() async {
    try {
      final response = await supabase
          .from('detailpenjualan')
          .select()
          .order('penjualanID', ascending: true);
      return response as List<dynamic>;
    } catch (e) {
      debugPrint('Error fetching detail penjualan: $e');
      rethrow;
    }
  }
}
