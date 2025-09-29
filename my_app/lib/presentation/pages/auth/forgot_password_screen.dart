import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';

enum ForgotPasswordStep { email, otp, newPassword, success }

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  ForgotPasswordStep _currentStep = ForgotPasswordStep.email;
  bool _isLoading = false;
  String? _email;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  int _resendCountdown = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      _email = _emailController.text.trim();

      // TODO: Implement actual password reset API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _currentStep = ForgotPasswordStep.otp;
        _isLoading = false;
      });

      _startResendCountdown();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reset code sent to $_email'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _verifyOTP() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final otp = _otpController.text.trim();

      // TODO: Implement actual OTP verification API call
      await Future.delayed(const Duration(seconds: 1));

      if (otp == '123456') {
        // Mock validation
        setState(() {
          _currentStep = ForgotPasswordStep.newPassword;
          _isLoading = false;
        });
      } else {
        throw Exception('Invalid OTP code');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Implement actual password reset API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _currentStep = ForgotPasswordStep.success;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _startResendCountdown() {
    setState(() => _resendCountdown = 60);

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;

      setState(() => _resendCountdown--);
      return _resendCountdown > 0;
    });
  }

  void _resendOTP() {
    if (_resendCountdown > 0) return;
    _sendResetEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _getStepTitle(),
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProgressIndicator(),
                const SizedBox(height: 32),
                _buildStepIcon(),
                const SizedBox(height: 24),
                _buildStepContent(),
                const SizedBox(height: 32),
                _buildActionButton(),
                const SizedBox(height: 16),
                _buildSecondaryAction(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final steps = ForgotPasswordStep.values;
    final currentIndex = steps.indexOf(_currentStep);

    return Row(
      children: steps.map((step) {
        final index = steps.indexOf(step);
        final isActive = index <= currentIndex;
        final isCurrent = index == currentIndex;

        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < steps.length - 1 ? 8 : 0),
            child: Column(
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getStepLabel(step),
                  style: TextStyle(
                    fontSize: 10,
                    color: isCurrent ? AppColors.primary : Colors.grey[600],
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStepIcon() {
    IconData icon;
    Color color;

    switch (_currentStep) {
      case ForgotPasswordStep.email:
        icon = Icons.email_outlined;
        color = AppColors.primary;
        break;
      case ForgotPasswordStep.otp:
        icon = Icons.verified_user_outlined;
        color = AppColors.warning;
        break;
      case ForgotPasswordStep.newPassword:
        icon = Icons.lock_reset;
        color = AppColors.info;
        break;
      case ForgotPasswordStep.success:
        icon = Icons.check_circle_outline;
        color = AppColors.success;
        break;
    }

    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 40, color: color),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case ForgotPasswordStep.email:
        return _buildEmailStep();
      case ForgotPasswordStep.otp:
        return _buildOTPStep();
      case ForgotPasswordStep.newPassword:
        return _buildNewPasswordStep();
      case ForgotPasswordStep.success:
        return _buildSuccessStep();
    }
  }

  Widget _buildEmailStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter your email address',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'We\'ll send you a verification code to reset your password.',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        CustomTextField(
          controller: _emailController,
          label: 'Email Address',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Email is required';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Enter a valid email address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildOTPStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter verification code',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'We\'ve sent a 6-digit code to $_email',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        CustomTextField(
          controller: _otpController,
          label: 'Verification Code',
          keyboardType: TextInputType.number,
          prefixIcon: Icons.verified_user,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Verification code is required';
            }
            if (value.length != 6) {
              return 'Enter a valid 6-digit code';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              'Didn\'t receive the code? ',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            GestureDetector(
              onTap: _resendOTP,
              child: Text(
                _resendCountdown > 0
                    ? 'Resend in ${_resendCountdown}s'
                    : 'Resend Code',
                style: TextStyle(
                  color: _resendCountdown > 0
                      ? AppColors.textSecondary
                      : AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNewPasswordStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Set new password',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose a strong password that you haven\'t used before.',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        CustomTextField(
          controller: _newPasswordController,
          label: 'New Password',
          obscureText: _obscureNewPassword,
          prefixIcon: Icons.lock_outline,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureNewPassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() => _obscureNewPassword = !_obscureNewPassword);
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
              return 'Password must contain uppercase, lowercase, and number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _confirmPasswordController,
          label: 'Confirm Password',
          obscureText: _obscureConfirmPassword,
          prefixIcon: Icons.lock_outline,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword,
              );
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _newPasswordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildPasswordStrengthIndicator(),
      ],
    );
  }

  Widget _buildSuccessStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Password Reset Successful!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Your password has been successfully reset. You can now login with your new password.',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    final password = _newPasswordController.text;
    final strength = _calculatePasswordStrength(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password Strength',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: strength / 4,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            strength <= 1
                ? AppColors.error
                : strength <= 2
                ? AppColors.warning
                : strength <= 3
                ? Colors.orange
                : AppColors.success,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _getPasswordStrengthLabel(strength),
          style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    String buttonText;
    VoidCallback? onPressed;

    switch (_currentStep) {
      case ForgotPasswordStep.email:
        buttonText = 'Send Reset Code';
        onPressed = _sendResetEmail;
        break;
      case ForgotPasswordStep.otp:
        buttonText = 'Verify Code';
        onPressed = _verifyOTP;
        break;
      case ForgotPasswordStep.newPassword:
        buttonText = 'Reset Password';
        onPressed = _resetPassword;
        break;
      case ForgotPasswordStep.success:
        buttonText = 'Back to Login';
        onPressed = () => Navigator.of(context).pushReplacementNamed('/login');
        break;
    }

    return CustomButton(
      text: buttonText,
      onPressed: _isLoading ? null : onPressed,
      isLoading: _isLoading,
    );
  }

  Widget _buildSecondaryAction() {
    if (_currentStep == ForgotPasswordStep.success) {
      return const SizedBox.shrink();
    }

    return Center(
      child: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text(
          'Back to Login',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case ForgotPasswordStep.email:
        return 'Forgot Password';
      case ForgotPasswordStep.otp:
        return 'Verify Code';
      case ForgotPasswordStep.newPassword:
        return 'New Password';
      case ForgotPasswordStep.success:
        return 'Success';
    }
  }

  String _getStepLabel(ForgotPasswordStep step) {
    switch (step) {
      case ForgotPasswordStep.email:
        return 'Email';
      case ForgotPasswordStep.otp:
        return 'Verify';
      case ForgotPasswordStep.newPassword:
        return 'Reset';
      case ForgotPasswordStep.success:
        return 'Done';
    }
  }

  int _calculatePasswordStrength(String password) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;
    return strength;
  }

  String _getPasswordStrengthLabel(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
      case 5:
        return 'Strong';
      default:
        return 'Weak';
    }
  }
}
