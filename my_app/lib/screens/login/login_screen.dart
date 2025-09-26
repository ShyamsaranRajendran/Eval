import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = AuthController();

  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Listen to auth controller changes
    _authController.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authController.removeListener(_onAuthStateChanged);
    super.dispose();
  }

  void _onAuthStateChanged() {
    if (_authController.isAuthenticated && mounted) {
      // Navigate to appropriate dashboard based on user role
      final route = _authController.getDashboardRoute();
      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await _authController.login(
        _emailController.text.trim(),
        _passwordController.text,
        rememberMe: _rememberMe,
      );

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _authController.errorMessage ?? AppStrings.loginFailed,
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (!AuthController.isValidEmail(value)) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (!AuthController.isValidPassword(value)) {
      return AppStrings.passwordTooShort;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Logo/Title
                  Icon(Icons.login, size: 80, color: AppColors.primary),
                  const SizedBox(height: 24),
                  Text(
                    AppStrings.appName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.login,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Email Field
                  CustomTextField(
                    controller: _emailController,
                    label: AppStrings.email,
                    hint: 'Enter your email',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  CustomTextField(
                    controller: _passwordController,
                    label: AppStrings.password,
                    hint: 'Enter your password',
                    prefixIcon: Icons.lock_outlined,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    obscureText: _obscurePassword,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 16),

                  // Remember Me & Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                            activeColor: AppColors.primary,
                          ),
                          Text(AppStrings.rememberMe),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Implement forgot password
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Forgot password feature coming soon',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          AppStrings.forgotPassword,
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  ListenableBuilder(
                    listenable: _authController,
                    builder: (context, child) {
                      return CustomButton(
                        text: AppStrings.login,
                        onPressed: _authController.isLoading
                            ? null
                            : _handleLogin,
                        isLoading: _authController.isLoading,
                      );
                    },
                  ),

                  // Error Message
                  ListenableBuilder(
                    listenable: _authController,
                    builder: (context, child) {
                      if (_authController.errorMessage != null) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            _authController.errorMessage!,
                            style: TextStyle(
                              color: AppColors.error,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
