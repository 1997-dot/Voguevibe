import '../../../../core/utils/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../sources/auth_local_source.dart';
import '../sources/auth_remote_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource remoteSource;
  final AuthLocalSource localSource;

  AuthRepositoryImpl({
    required this.remoteSource,
    required this.localSource,
  });

  @override
  Future<Result<User>> login({
    required String email,
    required String password,
  }) async {
    final result = await remoteSource.signIn(email: email, password: password);
    switch (result) {
      case Success(data: final user):
        final saveResult = await localSource.saveUser(user);
        if (saveResult case Failure(message: final msg)) {
          return Failure(msg);
        }
        return Success(user);
      case Failure(message: final message):
        return Failure(_mapErrorMessage(message));
    }
  }

  @override
  Future<Result<User>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final result = await remoteSource.signUp(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
    switch (result) {
      case Success(data: final user):
        final saveResult = await localSource.saveUser(user);
        if (saveResult case Failure(message: final msg)) {
          return Failure(msg);
        }
        return Success(user);
      case Failure(message: final message):
        return Failure(_mapErrorMessage(message));
    }
  }

  @override
  Future<Result<void>> logout() async {
    return await localSource.clearUser();
  }

  @override
  Future<Result<User?>> getSavedUser() async {
    return await localSource.getSavedUser();
  }

  @override
  Future<Result<bool>> isLoggedIn() async {
    final result = await localSource.getSavedUser();
    switch (result) {
      case Success(data: final user):
        return Success(user != null);
      case Failure(message: final message):
        return Failure(message);
    }
  }

  @override
  Future<Result<String?>> getToken() async {
    return await localSource.getToken();
  }

  @override
  Future<Result<User>> fetchProfile() async {
    final tokenResult = await localSource.getToken();
    String? token;
    switch (tokenResult) {
      case Success(data: final t):
        token = t;
      case Failure(message: final message):
        return Failure(message);
    }

    if (token == null) {
      return const Failure('No authentication token found');
    }

    final result = await remoteSource.getProfile(token);
    switch (result) {
      case Success(data: final user):
        await localSource.saveUser(user);
        return Success(user);
      case Failure(message: final message):
        return Failure(_mapErrorMessage(message));
    }
  }

  @override
  Future<Result<void>> updateUser(User user) async {
    final model = AuthUserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      token: user.token,
      profileImage: user.profileImage,
      address: user.address,
    );
    return await localSource.saveUser(model);
  }

  String _mapErrorMessage(String errorString) {
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
