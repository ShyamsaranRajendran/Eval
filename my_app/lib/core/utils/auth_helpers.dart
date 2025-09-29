import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Biometric authentication helper
class BiometricHelper {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _biometricCredentialsKey = 'biometric_credentials';

  /// Check if biometric authentication is available on device
  static Future<bool> isAvailable() async {
    try {
      // For now, return false as we haven't implemented biometric dependencies
      // In the future, you can use local_auth package:
      // final LocalAuthentication localAuth = LocalAuthentication();
      // return await localAuth.canCheckBiometrics;
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Check if biometric authentication is enabled by user
  static Future<bool> isEnabled() async {
    try {
      final enabled = await _storage.read(key: _biometricEnabledKey);
      return enabled == 'true';
    } catch (e) {
      return false;
    }
  }

  /// Enable biometric authentication
  static Future<void> enable(String email, String encryptedCredentials) async {
    await _storage.write(key: _biometricEnabledKey, value: 'true');
    await _storage.write(
      key: _biometricCredentialsKey,
      value: encryptedCredentials,
    );
  }

  /// Disable biometric authentication
  static Future<void> disable() async {
    await _storage.delete(key: _biometricEnabledKey);
    await _storage.delete(key: _biometricCredentialsKey);
  }

  /// Authenticate with biometrics
  static Future<Map<String, String>?> authenticate() async {
    try {
      if (!await isEnabled()) {
        return null;
      }

      // TODO: Implement actual biometric authentication
      // For now, return null (biometric not available)
      // In the future:
      // final LocalAuthentication localAuth = LocalAuthentication();
      // final bool didAuthenticate = await localAuth.authenticate(
      //   localizedReason: 'Please authenticate to sign in',
      //   options: const AuthenticationOptions(
      //     biometricOnly: true,
      //   ),
      // );

      // if (didAuthenticate) {
      //   final credentials = await _storage.read(key: _biometricCredentialsKey);
      //   // Decrypt and return credentials
      //   return decryptCredentials(credentials);
      // }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Simple haptic feedback for authentication
  static Future<void> triggerHapticFeedback() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (e) {
      // Ignore haptic errors
    }
  }
}

/// Authentication validation helpers
class AuthValidation {
  /// Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Validate password strength
  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validate password strength with detailed requirements
  static Map<String, bool> getPasswordStrength(String password) {
    return {
      'hasMinLength': password.length >= 8,
      'hasUppercase': password.contains(RegExp(r'[A-Z]')),
      'hasLowercase': password.contains(RegExp(r'[a-z]')),
      'hasNumbers': password.contains(RegExp(r'[0-9]')),
      'hasSpecialChar': password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
    };
  }

  /// Get password strength score (0-5)
  static int getPasswordScore(String password) {
    final strength = getPasswordStrength(password);
    return strength.values.where((requirement) => requirement).length;
  }

  /// Check if password is strong enough
  static bool isStrongPassword(String password) {
    return getPasswordScore(password) >= 3;
  }
}

/// Session management helpers
class SessionManager {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _sessionKey = 'user_session';
  static const String _lastActivityKey = 'last_activity';

  /// Save session data
  static Future<void> saveSession(Map<String, dynamic> sessionData) async {
    await _storage.write(
      key: _sessionKey,
      value: sessionData.toString(), // In production, use proper JSON encoding
    );
    await _updateLastActivity();
  }

  /// Get session data
  static Future<Map<String, dynamic>?> getSession() async {
    try {
      final sessionData = await _storage.read(key: _sessionKey);
      if (sessionData != null) {
        // In production, parse JSON properly
        return {'data': sessionData};
      }
    } catch (e) {
      // Handle parsing errors
    }
    return null;
  }

  /// Clear session
  static Future<void> clearSession() async {
    await _storage.delete(key: _sessionKey);
    await _storage.delete(key: _lastActivityKey);
  }

  /// Update last activity timestamp
  static Future<void> _updateLastActivity() async {
    await _storage.write(
      key: _lastActivityKey,
      value: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  /// Check if session is expired
  static Future<bool> isSessionExpired({
    Duration timeout = const Duration(hours: 24),
  }) async {
    try {
      final lastActivityStr = await _storage.read(key: _lastActivityKey);
      if (lastActivityStr != null) {
        final lastActivity = DateTime.fromMillisecondsSinceEpoch(
          int.parse(lastActivityStr),
        );
        return DateTime.now().difference(lastActivity) > timeout;
      }
    } catch (e) {
      // If we can't determine last activity, consider session expired
    }
    return true;
  }
}
