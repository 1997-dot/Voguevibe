import '../../../../core/utils/result.dart';
import '../entities/order.dart';
import '../repositories/checkout_repository.dart';

class PlaceOrderUseCase {
  final CheckoutFeatureRepository _repository;

  PlaceOrderUseCase(this._repository);

  Future<Result<OrderEntity>> call({
    required String userId,
    String? shippingAddress,
    String? paymentMethod,
  }) {
    return _repository.createOrder(
      userId: userId,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
    );
  }
}
