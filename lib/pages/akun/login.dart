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

  final LoginController loginController = LoginController();

Future<void> login() async {
  if (!_formKey.currentState!.validate()) return;

  print("Username: ${userController.text}");
  print("Password: ${passwordController.text}");

  try {
    await loginController.login(
      userController.text.trim(),
      passwordController.text.trim(),
    );
    final session = supabase.auth.currentSession;
    if (session != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ThemeColor.background,
          content: AwesomeSnackbarContent(
            title: 'Berhasil',
            message: 'Login Berhasil',
            contentType: ContentType.success,
          ),
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      throw Exception("Login gagal, tidak ada session aktif.");
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ThemeColor.background,
        content: AwesomeSnackbarContent(
          title: 'Gagal',
          message: 'Login gagal: $e',
          contentType: ContentType.failure,
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                label: 'Username',
                hintText: 'Nama Pengguna',
                controller: userController,
                validator: (value) =>
                    value!.isEmpty ? 'Field ini tidak boleh kosong' : null,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                label: 'Password',
                hintText: 'Password',
                controller: passwordController,
                isPassword: true,
                validator: (value) =>
                    value!.isEmpty ? 'Field ini tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: login,
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
