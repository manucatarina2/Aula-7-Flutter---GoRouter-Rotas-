import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
<<<<<<< HEAD
import 'package:flutterrotas/routes/app_router.dart';
=======
import 'routers/app_router.dart';
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
<<<<<<< HEAD
    url: 'https://pzzujwlcskytzwqydcvz.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB6enVqd2xjc2t5dHp3cXlkY3Z6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk0MjI4NTIsImV4cCI6MjA5NDk5ODg1Mn0.QtuC36PzVAHhCjt-zio9cgNbsP_JQCTD3Zzo1RAd5z8',
=======
    url: 'https://tfykfpmhudhuwjpkitzd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRmeWtmcG1odWRodXdqcGtpdHpkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkxMDg4MzksImV4cCI6MjA5NDY4NDgzOX0.RA7VDOc4i0nkI6EoK1aMz4ewCIOpNGYf99qtr65bhyM',
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
<<<<<<< HEAD
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
=======
      title: 'TabuadaPlay',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.pink[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.pink[300],
          foregroundColor: Colors.white,
          elevation: 0,
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
          centerTitle: true,
        ),
      ),
      routerConfig: appRouter,
    );
  }
}