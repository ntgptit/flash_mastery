import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../presentation/screens/dashboard/dashboard_screen.dart';

/// Application router configuration using go_router
class AppRouter {
  AppRouter._();

  /// Route paths
  static const String splash = '/';
  static const String dashboard = '/dashboard';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String deckDetail = '/deck/:id';
  static const String studySession = '/study/:id';
  static const String createFlashcard = '/create-flashcard';
  static const String editFlashcard = '/edit-flashcard/:id';

  /// Router configuration
  static final GoRouter router = GoRouter(
    initialLocation: dashboard,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: deckDetail,
        name: 'deckDetail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DeckDetailScreen(deckId: id);
        },
      ),
      GoRoute(
        path: studySession,
        name: 'studySession',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return StudySessionScreen(deckId: id);
        },
      ),
      GoRoute(
        path: createFlashcard,
        name: 'createFlashcard',
        builder: (context, state) => const CreateFlashcardScreen(),
      ),
      GoRoute(
        path: editFlashcard,
        name: 'editFlashcard',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return EditFlashcardScreen(flashcardId: id);
        },
      ),
    ],
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
}

// ==================== PLACEHOLDER SCREENS ====================
// These are temporary placeholder screens.
// Replace with actual screen implementations.

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Home Screen')),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(child: Text('Login Screen')),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: const Center(child: Text('Register Screen')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Screen')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Screen')),
    );
  }
}

class DeckDetailScreen extends StatelessWidget {
  final String deckId;

  const DeckDetailScreen({super.key, required this.deckId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Deck $deckId')),
      body: Center(child: Text('Deck Detail Screen: $deckId')),
    );
  }
}

class StudySessionScreen extends StatelessWidget {
  final String deckId;

  const StudySessionScreen({super.key, required this.deckId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Session')),
      body: Center(child: Text('Study Session Screen: $deckId')),
    );
  }
}

class CreateFlashcardScreen extends StatelessWidget {
  const CreateFlashcardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Flashcard')),
      body: const Center(child: Text('Create Flashcard Screen')),
    );
  }
}

class EditFlashcardScreen extends StatelessWidget {
  final String flashcardId;

  const EditFlashcardScreen({super.key, required this.flashcardId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Flashcard')),
      body: Center(child: Text('Edit Flashcard Screen: $flashcardId')),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final Exception? error;

  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text('Error: ${error?.toString() ?? "Unknown error"}'),
      ),
    );
  }
}
