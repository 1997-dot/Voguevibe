import '../../../../core/utils/result.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Result<User>> login({
    required String email,
    required String password,
  });

  Future<Result<User>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  });

  Future<Result<void>> logout();

  Future<Result<User?>> getSavedUser();

  Future<Result<bool>> isLoggedIn();

  Future<Result<String?>> getToken();

  Future<Result<User>> fetchProfile();

  Future<Result<void>> updateUser(User user);
}
