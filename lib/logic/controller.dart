import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;

class LoginController {
  Future<void> login(String email, String password, String username) async {
    final userdata = await supabase.from('user').select();
    final loginresponse = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return;
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
