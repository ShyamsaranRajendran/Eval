import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../constants/strings.dart';

class AuthController extends ChangeNotifier {
  static final AuthController _instance = AuthController._internal();
  factory AuthController() => _instance;
  AuthController._internal();

  final ApiService _apiService = ApiService();

  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get isReviewer => _currentUser?.isReviewer ?? false;

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Login method
  Future<bool> login(
    String email,
    String password, {
    bool rememberMe = false,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final loginRequest = LoginRequest(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      final loginResponse = await _apiService.login(loginRequest);

      // Store user data
      _currentUser = loginResponse.user;
      _isAuthenticated = true;

      // Save to local storage if remember me is checked
      if (rememberMe) {
        await _saveUserData(loginResponse);
      }

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      if (e.toString().contains('Invalid')) {
        _setError(AppStrings.invalidCredentials);
      } else if (e.toString().contains('network') ||
          e.toString().contains('connection')) {
        _setError(AppStrings.networkError);
      } else {
        _setError(AppStrings.somethingWentWrong);
      }
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    _setLoading(true);

    try {
      await _apiService.logout();
    } catch (e) {
      // Even if API call fails, we should still logout locally
      if (kDebugMode) {
        print('Logout API error: $e');
      }
    } finally {
      // Clear local data
      await _clearUserData();
      _currentUser = null;
      _isAuthenticated = false;
      _apiService.clearTokens();

      _setLoading(false);
      notifyListeners();
    }
  }

  // Check if user is already logged in (on app start)
  Future<void> checkAuthStatus() async {
    _setLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      final accessToken = prefs.getString('access_token');

      if (userData != null && accessToken != null) {
        // Try to get user profile to validate token
        _apiService.setTokens(accessToken);

        try {
          final user = await _apiService.getUserProfile();
          _currentUser = user;
          _isAuthenticated = true;
        } catch (e) {
          // Token might be expired, clear stored data
          await _clearUserData();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Auth status check error: $e');
      }
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Refresh user profile
  Future<void> refreshUserProfile() async {
    if (!_isAuthenticated) return;

    try {
      final user = await _apiService.getUserProfile();
      _currentUser = user;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Profile refresh error: $e');
      }
    }
  }

  // Update user profile
  Future<bool> updateProfile(Map<String, dynamic> profileData) async {
    if (!_isAuthenticated) return false;

    _setLoading(true);
    _setError(null);

    try {
      // This would be an API call to update profile
      // await _apiService.updateProfile(profileData);

      // For now, just refresh the profile
      await refreshUserProfile();

      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(AppStrings.somethingWentWrong);
      return false;
    }
  }

  // Save user data to local storage
  Future<void> _saveUserData(LoginResponse loginResponse) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', loginResponse.user.toString());
    await prefs.setString('access_token', loginResponse.accessToken);
    if (loginResponse.refreshToken != null) {
      await prefs.setString('refresh_token', loginResponse.refreshToken!);
    }
  }

  // Clear user data from local storage
  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  // Validate email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate password strength
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  // Get appropriate dashboard route based on user role
  String getDashboardRoute() {
    if (_currentUser == null) return '/login';

    if (_currentUser!.isAdmin) {
      return '/admin-dashboard';
    } else if (_currentUser!.isReviewer) {
      return '/reviewer-dashboard';
    } else {
      return '/login';
    }
  }

  @override
  void dispose() {
    // Clean up resources if needed
    super.dispose();
  }
}
