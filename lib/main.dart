import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutterrotas/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://pzzujwlcskytzwqydcvz.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB6enVqd2xjc2t5dHp3cXlkY3Z6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk0MjI4NTIsImV4cCI6MjA5NDk5ODg1Mn0.QtuC36PzVAHhCjt-zio9cgNbsP_JQCTD3Zzo1RAd5z8',
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Multiplica+',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFFFFD700),
        scaffoldBackgroundColor: const Color(0xFFFFF8E1),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFFFD700),
          secondary: Color(0xFFFFC107),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFD700),
          foregroundColor: Color(0xFF5D4037),
          centerTitle: true,
        ),
      ),
      routerConfig: appRouter,
    );
  }
}