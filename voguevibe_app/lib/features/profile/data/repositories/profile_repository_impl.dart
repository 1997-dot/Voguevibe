import '../../../../core/utils/result.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../sources/profile_remote_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource dataSource;

  ProfileRepositoryImpl({required this.dataSource});

  @override
  Future<Result<UserProfile>> getUserProfile() async {
    return await dataSource.getUserProfile();
  }

  @override
  Future<Result<void>> updateProfile(UserProfile profile) async {
    // Not implemented yet — edit profile button is non-functional
    return const Failure('Not implemented');
  }

  @override
  Future<Result<List<Order>>> getOrderHistory(String userId) async {
    return await dataSource.getOrderHistory(userId);
  }
}
