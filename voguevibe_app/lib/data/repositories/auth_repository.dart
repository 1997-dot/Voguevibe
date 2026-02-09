import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;
  static const String _userKey = 'saved_user';
  static const String _tokenKey = 'auth_token';

  AuthRepository({AuthService? authService})
      : _authService = authService ?? AuthService();

  /// Login with email and password
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _authService.signIn(
        email: email,
        password: password,
      );
      await _saveUser(user);
      return user;
    } catch (e) {
      throw Exception(_mapErrorMessage(e));
    }
  }

  /// Register new user
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final user = await _authService.signUp(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      await _saveUser(user);
      return user;
    } catch (e) {
      throw Exception(_mapErrorMessage(e));
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_tokenKey);
    } catch (e) {
      throw Exception('Failed to logout: ${e.toString()}');
    }
  }

  /// Get saved user from local storage
  Future<UserModel?> getSavedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);

      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final user = await getSavedUser();
    return user != null;
  }

  /// Get saved token
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Save user to local storage
  Future<void> _saveUser(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = json.encode(user.toJson());
      await prefs.setString(_userKey, userJson);
      await prefs.setString(_tokenKey, user.token);
    } catch (e) {
      throw Exception('Failed to save user data: ${e.toString()}');
    }
  }

  /// Update saved user
  Future<void> updateUser(UserModel user) async {
    await _saveUser(user);
  }

  /// Fetch user profile from API
  Future<UserModel> fetchProfile() async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final user = await _authService.getProfile(token);
      await _saveUser(user);
      return user;
    } catch (e) {
      throw Exception(_mapErrorMessage(e));
    }
  }

  /// Map error messages to user-friendly text
  String _mapErrorMessage(dynamic error) {
    final errorString = error.toString();

    if (errorString.contains('Invalid credentials')) {
      return 'Invalid email or password';
    } else if (errorString.contains('Email already exists')) {
      return 'This email is already registered';
    } else if (errorString.contains('Connection timeout') ||
        errorString.contains('No internet connection')) {
      return 'Please check your internet connection';
    } else if (errorString.contains('Server error')) {
      return 'Server is currently unavailable. Please try again later.';
    }

    return errorString.replaceAll('Exception: ', '');
  }
}
