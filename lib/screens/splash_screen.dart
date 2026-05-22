import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
<<<<<<< HEAD
import 'package:supabase_flutter/supabase_flutter.dart';
=======
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

<<<<<<< HEAD
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        context.go('/home');
      } else {
=======
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
        context.go('/login');
      }
    });
  }

  @override
<<<<<<< HEAD
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.amber[300]!, Colors.amber[100]!],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calculate,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Multiplica+',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[800],
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Aprenda tabuadas de forma divertida!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.amber[800],
                ),
              ),
              const SizedBox(height: 40),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
=======
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withValues(
                              alpha:
                                  0.3), // Corrigido: withOpacity -> withValues
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.school,
                      size: 80,
                      color: Colors.amber[800],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'EduStream',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[700],
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Streaming Educacional',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.brown[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 48),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                ],
              ),
            ),
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
          ),
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
