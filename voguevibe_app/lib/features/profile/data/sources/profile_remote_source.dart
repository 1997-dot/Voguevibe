import '../../../../core/network/api_client.dart';
import '../../../../core/utils/result.dart';
import '../models/order_model.dart';
import '../models/user_profile_model.dart';

class ProfileRemoteSource {
  final ApiClient apiClient;

  ProfileRemoteSource(this.apiClient);

  Future<Result<UserProfileModel>> getUserProfile() async {
    return await apiClient.get(
      '/profile',
      fromJson: (json) => UserProfileModel.fromJson(json),
    );
  }

  Future<Result<void>> updateProfile(UserProfileModel profile) async {
    return await apiClient.put(
      '/profile',
      data: profile.toJson(),
      fromJson: (_) {},
    );
  }

  Future<Result<List<OrderModel>>> getOrderHistory() async {
    return await apiClient.get(
      '/profile/orders',
      fromJson: (json) => (json as List)
          .map((item) => OrderModel.fromJson(item))
          .toList(),
    );
  }
}
