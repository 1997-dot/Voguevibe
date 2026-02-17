import '../../../../core/utils/result.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../sources/checkout_remote_source.dart';

class CheckoutRepositoryImpl implements CheckoutFeatureRepository {
  final CheckoutDataSource _dataSource;

  CheckoutRepositoryImpl({required CheckoutDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<Result<OrderEntity>> createOrder({
    required String userId,
    String? shippingAddress,
    String? paymentMethod,
  }) async {
    final result = await _dataSource.createOrder(
      userId: userId,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
    );
    switch (result) {
      case Success(data: final order):
        return Success(order);
      case Failure(message: final msg):
        return Failure(msg);
    }
  }

  @override
  Future<Result<List<OrderEntity>>> getUserOrders(String userId) async {
    final result = await _dataSource.getUserOrders(userId);
    switch (result) {
      case Success(data: final orders):
        return Success(List<OrderEntity>.from(orders));
      case Failure(message: final msg):
        return Failure(msg);
    }
  }
}
