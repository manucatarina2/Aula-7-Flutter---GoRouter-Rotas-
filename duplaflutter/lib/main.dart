import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Multiplica+',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF8E1),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFF3E0),
          foregroundColor: Colors.brown,
          elevation: 0,
          centerTitle: true,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          primary: Colors.orange[700]!,
          surface: const Color(0xFFFFF8E1),
        ),
      ),
      routerConfig: appRouter,
    );
  }
}
