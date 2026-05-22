import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/history_screen.dart';
import '../screens/profile_screen.dart';

final _supabase = Supabase.instance.client;

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
      redirect: (context, state) {
        final session = _supabase.auth.currentSession;
        if (session == null) return '/login';
        return null;
      },
    ),
    GoRoute(
      path: '/detail/:id',
      name: 'detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final extra = state.extra as Map<String, dynamic>?;
        return DetailScreen(
          videoId: id,
          title: extra?['title'] ?? '',
          description: extra?['description'] ?? '',
          imageUrl: extra?['imageUrl'] ?? '',
          category: extra?['category'] ?? '',
          numero: extra?['numero'] ?? 0,
          videoUrl: extra?['videoUrl'] ?? '',
        );
      },
      redirect: (context, state) {
        final session = _supabase.auth.currentSession;
        if (session == null) return '/login';
        return null;
      },
    ),
    GoRoute(
      path: '/favorites',
      name: 'favorites',
      builder: (context, state) => const FavoritesScreen(),
      redirect: (context, state) {
        final session = _supabase.auth.currentSession;
        if (session == null) return '/login';
        return null;
      },
    ),
    GoRoute(
      path: '/history',
      name: 'history',
      builder: (context, state) => const HistoryScreen(),
      redirect: (context, state) {
        final session = _supabase.auth.currentSession;
        if (session == null) return '/login';
        return null;
      },
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
      redirect: (context, state) {
        final session = _supabase.auth.currentSession;
        if (session == null) return '/login';
        return null;
      },
    ),
  ],
);