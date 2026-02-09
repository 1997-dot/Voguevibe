import '../../../../core/utils/result.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/user_profile_model.dart';
import '../sources/profile_remote_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteSource remoteSource;

  ProfileRepositoryImpl(this.remoteSource);

  @override
  Future<Result<UserProfile>> getUserProfile() async {
    return await remoteSource.getUserProfile();
  }

  @override
  Future<Result<void>> updateProfile(UserProfile profile) async {
    final profileModel = UserProfileModel(
      id: profile.id,
      name: profile.name,
      email: profile.email,
      phone: profile.phone,
      address: profile.address,
    );
    return await remoteSource.updateProfile(profileModel);
  }

  @override
  Future<Result<List<Order>>> getOrderHistory() async {
    return await remoteSource.getOrderHistory();
  }
}
