import 'package:flutter/foundation.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository();

  /// Current logged-in user
  UserModel? get currentUser => _currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => _currentUser != null;

  /// Loading state
  bool get isLoading => _isLoading;

  /// Error message
  String? get errorMessage => _errorMessage;

  /// User ID (for linking data)
  String? get userId => _currentUser?.id;

  /// Initialize auth state on app start
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final savedUser = await _authRepository.getSavedUser();
      if (savedUser != null) {
        _currentUser = savedUser;
      }
    } catch (e) {
      _errorMessage = 'Failed to load user data';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authRepository.login(
        email: email,
        password: password,
      );
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Register new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authRepository.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authRepository.logout();
      _currentUser = null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to logout';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh user profile from API
  Future<void> refreshProfile() async {
    if (_currentUser == null) return;

    try {
      final updatedUser = await _authRepository.fetchProfile();
      _currentUser = updatedUser;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to refresh profile';
    }
  }

  /// Update user data locally
  void updateUser(UserModel user) {
    _currentUser = user;
    _authRepository.updateUser(user);
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Check if user is logged in
  Future<bool> checkAuthStatus() async {
    return await _authRepository.isLoggedIn();
  }
}
