import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetProfileUseCase _getProfileUseCase;

  AuthCubit({
    required AuthRepository authRepository,
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetProfileUseCase getProfileUseCase,
  })  : _authRepository = authRepository,
        _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _getProfileUseCase = getProfileUseCase,
        super(AuthInitial());

  /// Get current user from state
  User? get currentUser {
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

    final result = await _authRepository.getSavedUser();
    switch (result) {
      case Success(data: final savedUser):
        if (savedUser != null) {
          emit(AuthAuthenticated(savedUser));
        } else {
          emit(AuthUnauthenticated());
        }
      case Failure(message: final message):
        emit(AuthError(message));
    }
  }

  /// Login with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await _loginUseCase(email: email, password: password);
    switch (result) {
      case Success(data: final user):
        emit(AuthAuthenticated(user));
        return true;
      case Failure(message: final message):
        emit(AuthError(message));
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

    final result = await _registerUseCase(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
    switch (result) {
      case Success(data: final user):
        emit(AuthAuthenticated(user));
        return true;
      case Failure(message: final message):
        emit(AuthError(message));
        return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    emit(AuthLoading());

    final result = await _logoutUseCase();
    switch (result) {
      case Success():
        emit(AuthUnauthenticated());
      case Failure():
        emit(AuthError('Failed to logout'));
    }
  }

  /// Refresh user profile from API
  Future<void> refreshProfile() async {
    if (currentUser == null) return;

    final result = await _getProfileUseCase();
    switch (result) {
      case Success(data: final updatedUser):
        emit(AuthAuthenticated(updatedUser));
      case Failure():
        emit(AuthError('Failed to refresh profile'));
    }
  }

  /// Update user data locally
  Future<void> updateUser(User user) async {
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
    final result = await _authRepository.isLoggedIn();
    switch (result) {
      case Success(data: final isLoggedIn):
        return isLoggedIn;
      case Failure():
        return false;
    }
  }
}
