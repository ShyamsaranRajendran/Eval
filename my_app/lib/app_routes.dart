import 'package:flutter/material.dart';
import 'presentation/pages/splash/splash_screen.dart';
import 'presentation/pages/auth/modern_login_screen.dart';
import 'presentation/pages/auth/forgot_password_screen.dart';
import 'presentation/pages/admin/comprehensive_admin_dashboard.dart';
import 'presentation/pages/coordinator/comprehensive_coordinator_dashboard.dart';
import 'presentation/pages/faculty/comprehensive_faculty_dashboard.dart';

class AppRoutes {
  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String adminDashboard = '/admin-dashboard';
  static const String coordinatorDashboard = '/coordinator-dashboard';
  static const String facultyDashboard = '/faculty-dashboard';

  // Route generator
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
          settings: settings,
        );

      case login:
        return MaterialPageRoute(
          builder: (context) => const ModernLoginScreen(),
          settings: settings,
        );

      case forgotPassword:
        return MaterialPageRoute(
          builder: (context) => const ForgotPasswordScreen(),
          settings: settings,
        );

      case adminDashboard:
        return MaterialPageRoute(
          builder: (context) => const ComprehensiveAdminDashboard(),
          settings: settings,
        );
      case coordinatorDashboard:
        return MaterialPageRoute(
          builder: (context) => const ComprehensiveCoordinatorDashboard(),
          settings: settings,
        );

      case facultyDashboard:
        return MaterialPageRoute(
          builder: (context) => const ComprehensiveFacultyDashboard(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const UnknownRoute(),
          settings: settings,
        );
    }
  }

  // Helper methods for navigation
  static void navigateToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(login);
  }

  static void navigateToAdminDashboard(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(adminDashboard);
  }

  static void navigateToCoordinatorDashboard(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(coordinatorDashboard);
  }

  static void navigateToFacultyDashboard(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(facultyDashboard);
  }

  // Clear stack and navigate
  static void clearAndNavigateTo(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  // Check if can pop
  static bool canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }
}

// Placeholder dashboard screens
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AppRoutes.navigateToLogin(context),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Admin Dashboard - Coming Soon',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class CoordinatorDashboard extends StatelessWidget {
  const CoordinatorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coordinator Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AppRoutes.navigateToLogin(context),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Coordinator Dashboard - Coming Soon',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class FacultyDashboard extends StatelessWidget {
  const FacultyDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AppRoutes.navigateToLogin(context),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Faculty Dashboard - Coming Soon',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// Unknown route widget
class UnknownRoute extends StatelessWidget {
  const UnknownRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              '404 - Page Not Found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
