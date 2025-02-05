import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class LoginController {
  late String email;
  late String password;
  Future<void> login() async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return;
  }
}

class ProdukController {
  Future<void> fetchproduk() async {
    await supabase.from('produk').select();
  }
}
