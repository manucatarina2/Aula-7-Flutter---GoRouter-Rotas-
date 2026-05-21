import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'routers/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://tfykfpmhudhuwjpkitzd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRmeWtmcG1odWRodXdqcGtpdHpkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkxMDg4MzksImV4cCI6MjA5NDY4NDgzOX0.RA7VDOc4i0nkI6EoK1aMz4ewCIOpNGYf99qtr65bhyM',
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TabuadaPlay',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.pink[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.pink[300],
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      routerConfig: appRouter,
    );
  }
}