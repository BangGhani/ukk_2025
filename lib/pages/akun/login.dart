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
  final AuthController authController = AuthController();
  final FocusNode _passwordFocusNode = FocusNode();

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    debugPrint("Username: ${userController.text}");
    debugPrint("Password: ${passwordController.text}");

    try {
      await authController.login(
        userController.text.trim(),
        passwordController.text.trim(),
      );

      if (supabase.auth.currentSession != null) {
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
      }
    } catch (e) {
      debugPrint('Login gagal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ThemeColor.background,
          content: AwesomeSnackbarContent(
            title: 'Gagal',
            message: 'Login gagal, mohon periksa kredensial Anda',
            contentType: ContentType.failure,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 60),
              Center(
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/app_logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'eCashier',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Username',
                      hintText: 'Masukkan username Anda',
                      controller: userController,
                      prefixIcon: const Icon(Icons.person_outline),
                      validator: (value) => value!.isEmpty
                          ? 'Field ini tidak boleh kosong'
                          : null,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Password',
                      hintText: 'Masukkan password Anda',
                      controller: passwordController,
                      isPassword: true,
                      prefixIcon: const Icon(Icons.lock_outline),
                      validator: (value) => value!.isEmpty
                          ? 'Field ini tidak boleh kosong'
                          : null,
                      textInputAction: TextInputAction.go,
                      onSubmitted: (_) => login(),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeColor.hijau,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          'MASUK',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // TextButton(
              //   onPressed: () {
              //     // Navigasi ke lupa password
              //   },
              //   child: const Text(
              //     'Lupa Password?',
              //     style: TextStyle(
              //       color: ThemeColor.hijau,
              //       decoration: TextDecoration.underline,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
