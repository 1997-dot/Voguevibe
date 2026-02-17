import '../../../../core/utils/result.dart';
import '../../../../data/managers/user_data_manager.dart';
import '../../../auth/data/sources/auth_local_source.dart';
import '../models/order_model.dart';
import '../models/user_profile_model.dart';

/// Data source that bridges to legacy AuthLocalSource and UserDataManager,
/// copying exact logic from the original ProfilePage's data access.
class ProfileDataSource {
  final AuthLocalSource _authLocalSource = AuthLocalSource();
  final UserDataManager _userDataManager = UserDataManager();

  /// Get user profile from local auth storage.
  Future<Result<UserProfileModel>> getUserProfile() async {
    final result = await _authLocalSource.getSavedUser();
    switch (result) {
      case Success(data: final user):
        if (user != null) {
          return Success(UserProfileModel.fromLegacy(user));
        }
        return const Failure('No user found');
      case Failure(message: final msg):
        return Failure(msg);
    }
  }

  /// Get user order history from UserDataManager.
  Future<Result<List<OrderModel>>> getOrderHistory(String userId) async {
    try {
      final legacyOrders = await _userDataManager.getUserOrders(userId);
      final orders =
          legacyOrders.map((order) => OrderModel.fromLegacy(order)).toList();
      return Success(orders);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
