import '../../../../core/utils/result.dart';
import '../entities/order.dart';

/// Abstract contract for the checkout feature repository.
abstract class CheckoutFeatureRepository {
  Future<Result<OrderEntity>> createOrder({
    required String userId,
    String? shippingAddress,
    String? paymentMethod,
  });
  Future<Result<List<OrderEntity>>> getUserOrders(String userId);
}
