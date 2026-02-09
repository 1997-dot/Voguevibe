import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(AuthInitial());

  /// Get current user from state
  UserModel? get currentUser {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      return currentState.user;
    }
    return null;
  }

  /// Check if user is authenticated
  bool get isAuthenticated => state is AuthAuthenticated;

  /// Check if loading
  bool get isLoading => state is AuthLoading;

  /// Get error message
  String? get errorMessage {
    final currentState = state;
    if (currentState is AuthError) {
      return currentState.message;
    }
    return null;
  }

  /// User ID (for linking data)
  String? get userId => currentUser?.id;

  /// Initialize auth state on app start
  Future<void> initialize() async {
    emit(AuthLoading());

    try {
      final savedUser = await _authRepository.getSavedUser();
      if (savedUser != null) {
        emit(AuthAuthenticated(savedUser));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError('Failed to load user data'));
    }
  }

  /// Login with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      final user = await _authRepository.login(
        email: email,
        password: password,
      );
      emit(AuthAuthenticated(user));
      return true;
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      emit(AuthError(errorMessage));
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
    emit(AuthLoading());

    try {
      final user = await _authRepository.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      emit(AuthAuthenticated(user));
      return true;
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      emit(AuthError(errorMessage));
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    emit(AuthLoading());

    try {
      await _authRepository.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Failed to logout'));
    }
  }

  /// Refresh user profile from API
  Future<void> refreshProfile() async {
    if (currentUser == null) return;

    try {
      final updatedUser = await _authRepository.fetchProfile();
      emit(AuthAuthenticated(updatedUser));
    } catch (e) {
      emit(AuthError('Failed to refresh profile'));
    }
  }

  /// Update user data locally
  Future<void> updateUser(UserModel user) async {
    await _authRepository.updateUser(user);
    emit(AuthAuthenticated(user));
  }

  /// Clear error message (return to unauthenticated state)
  void clearError() {
    if (state is AuthError) {
      emit(AuthUnauthenticated());
    }
  }

  /// Check if user is logged in
  Future<bool> checkAuthStatus() async {
    return await _authRepository.isLoggedIn();
  }
}
