import '../../../../core/utils/result.dart';
import '../../../../data/managers/user_data_manager.dart';
import '../../../../data/models/order_model.dart';
import '../../../../data/repositories/product_repository.dart';
import '../models/order_model.dart';

/// Data source that wraps legacy ProductRepository, UserDataManager,
/// and OrderModel, copying exact logic from the original CheckoutCubit.
class CheckoutDataSource {
  final ProductRepository _repository = ProductRepository();
  final UserDataManager _userDataManager = UserDataManager();

  /// Create order: get cart, build order, save, clear cart.
  Future<Result<CheckoutOrderModel>> createOrder({
    required String userId,
    String? shippingAddress,
    String? paymentMethod,
  }) {
    return _tryAsync(() async {
      final cartProducts = _repository.getCartProducts();

      if (cartProducts.isEmpty) {
        throw Exception('Cart is empty');
      }

      final order = OrderModel.fromCartProducts(
        cartProducts: cartProducts,
        shippingAddress: shippingAddress,
        paymentMethod: paymentMethod,
      );

      await _userDataManager.addOrder(userId, order);

      _repository.clearCart();
      await _userDataManager.clearCart(userId);

      return CheckoutOrderModel.fromLegacy(order);
    });
  }

  /// Load user order history.
  Future<Result<List<CheckoutOrderModel>>> getUserOrders(String userId) {
    return _tryAsync(() async {
      final orders = await _userDataManager.getUserOrders(userId);
      return orders
          .map((order) => CheckoutOrderModel.fromLegacy(order))
          .toList();
    });
  }

  /// Helper to wrap async operations in Result.
  Future<Result<T>> _tryAsync<T>(Future<T> Function() fn) async {
    try {
      final data = await fn();
      return Success(data);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
