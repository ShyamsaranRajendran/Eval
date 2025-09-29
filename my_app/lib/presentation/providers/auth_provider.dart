import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/models/user_models.dart';
import '../../data/services/auth_service.dart';
import '../../core/constants/app_constants.dart';

/// Auth state class
class AuthState {
  final UserModel? user;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Auth provider
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final FlutterSecureStorage _storage;

  AuthNotifier(this._authService, this._storage) : super(const AuthState()) {
    _checkAuthStatus();
  }

  /// Check if user is already authenticated
  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    try {
      final token = await _storage.read(key: AppConstants.accessTokenKey);
      if (token != null) {
        // Set token in API client
        await _authService.setAccessToken(token);

        // Get current user
        final user = await _authService.getCurrentUser();
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      // Token might be expired, clear it
      await logout();
      state = state.copyWith(
        isLoading: false,
        error: 'Session expired. Please login again.',
      );
    }
  }

  /// Login user
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Basic validation
      if (email.trim().isEmpty) {
        throw Exception('Email is required');
      }
      if (password.trim().isEmpty) {
        throw Exception('Password is required');
      }

      final request = LoginRequest(email: email.trim(), password: password);
      final response = await _authService.login(request);

      // Store tokens securely
      await _storage.write(
        key: AppConstants.accessTokenKey,
        value: response.accessToken,
      );
      await _storage.write(
        key: AppConstants.refreshTokenKey,
        value: response.refreshToken,
      );

      // Set token in API client
      await _authService.setAccessToken(response.accessToken);

      state = state.copyWith(
        user: response.user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      String errorMessage = 'Login failed. Please try again.';

      // Handle specific error types
      if (e.toString().contains('401') ||
          e.toString().contains('Unauthorized')) {
        errorMessage =
            'Invalid email or password. Please check your credentials.';
      } else if (e.toString().contains('network') ||
          e.toString().contains('connection')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (e.toString().contains('timeout')) {
        errorMessage = 'Request timeout. Please try again.';
      } else if (e.toString().contains('Email is required')) {
        errorMessage = 'Email is required';
      } else if (e.toString().contains('Password is required')) {
        errorMessage = 'Password is required';
      }

      state = state.copyWith(isLoading: false, error: errorMessage);
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      // Ignore logout errors, just clear local data
      debugPrint('Logout error: $e');
    }

    await _storage.deleteAll();
    state = const AuthState();
  }

  /// Register user (admin only)
  Future<UserModel?> register(RegisterRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authService.register(request);
      state = state.copyWith(isLoading: false);
      return user;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  /// Update profile
  Future<void> updateProfile(UpdateUserRequest request) async {
    if (state.user == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final updatedUser = await _authService.updateProfile(
        state.user!.id,
        request,
      );
      state = state.copyWith(user: updatedUser, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Providers
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthNotifier(authService, storage);
});

/// Helper providers
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final userRoleProvider = Provider<UserRole?>((ref) {
  return ref.watch(authProvider).user?.role;
});

final canManageUsersProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role?.canManageUsers ?? false;
});

final canCreatePanelsProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role?.canCreatePanels ?? false;
});

final canSuperviseEvaluationsProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role?.canSuperviseEvaluations ?? false;
});

final canEvaluateProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role?.canEvaluate ?? false;
});

final canViewReportsProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role?.canViewReports ?? false;
});
