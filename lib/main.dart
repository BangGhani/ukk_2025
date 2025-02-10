import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'components/themes.dart';
import 'logic/controller.dart';
import 'pages/akun/login.dart';
import 'pages/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);
  await Supabase.initialize(
    url: 'https://iakmjmtnsihsowsgnyxr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlha21qbXRuc2loc293c2dueXhyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg3MTM4MjEsImV4cCI6MjA1NDI4OTgyMX0.NFsmDwKyxfExC8B-vJbzvbrZz0s8kHmRMtQnD4OgQR8',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final session = supabase.auth.currentSession;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UKK 2025',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: ThemeColor.background,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.green,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
          ),
        ),
      ),
      home: session != null ? const HomePage() : const LoginPage(),
    );
  }
}
