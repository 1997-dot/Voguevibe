import '../../../../core/utils/result.dart';
import '../entities/order.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<Result<UserProfile>> getUserProfile();
  Future<Result<void>> updateProfile(UserProfile profile);
  Future<Result<List<Order>>> getOrderHistory(String userId);
}
