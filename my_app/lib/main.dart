import 'package:flutter/material.dart';
import 'app_routes.dart';
import 'constants/colors.dart';
import 'constants/strings.dart';
import 'controllers/auth_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      initialRoute: AppRoutes.initialRoute,
      onGenerateRoute: AppRoutes.generateRoute,
      home: const SplashScreen(),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.greyLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: AppColors.textPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.textPrimary),
        bodySmall: TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController _authController = AuthController();

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Check authentication status
    await _authController.checkAuthStatus();

    // Add a small delay for splash screen effect
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      if (_authController.isAuthenticated) {
        // Navigate to appropriate dashboard based on user role
        final route = _authController.getDashboardRoute();
        Navigator.of(context).pushReplacementNamed(route);
      } else {
        // Navigate to login screen
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Icon(Icons.admin_panel_settings, size: 100, color: AppColors.white),
            SizedBox(height: 24),

            // App Name
            Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            SizedBox(height: 8),

            // App Version
            Text(
              'Version ${AppStrings.appVersion}',
              style: TextStyle(fontSize: 14, color: AppColors.white),
            ),
            SizedBox(height: 48),

            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
