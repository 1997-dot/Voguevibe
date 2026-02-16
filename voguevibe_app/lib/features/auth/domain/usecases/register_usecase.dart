import '../../../../core/utils/result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Result<User>> call({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    return await repository.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
  }
}
