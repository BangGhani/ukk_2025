import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:ukk_2025/components/themes.dart';
import '../../components/form.dart';
import '../../logic/controller.dart';
import '../home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    try {
      if (_formKey.currentState!.validate()) {
        final response = await supabase.auth.signInWithPassword(
          email: userController.text,
          password: passwordController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: ThemeColor.putih,
            content: AwesomeSnackbarContent(
                title: 'Berhasil',
                message: 'Login Berhasil',
                contentType: ContentType.success)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ThemeColor.putih,
          content: AwesomeSnackbarContent(
              title: 'Gagal',
              message: 'Login gagal: $e',
              contentType: ContentType.failure)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                label: 'Email',
                hintText: 'email@gmail.com',
                controller: userController,
                validator: (value) => value!.isEmpty ? 'Field ini tidak boleh kosong' : null,
              ),
              SizedBox(height: 10),
              CustomTextField(
                label: 'Password',
                hintText: 'Password',
                controller: passwordController,
                isPassword: true,
                validator: (value) => value!.isEmpty ? 'Field ini tidak boleh kosong' : null
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
