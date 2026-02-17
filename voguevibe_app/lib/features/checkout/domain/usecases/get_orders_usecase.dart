import '../../../../core/utils/result.dart';
import '../entities/order.dart';
import '../repositories/checkout_repository.dart';

class GetOrdersUseCase {
  final CheckoutFeatureRepository _repository;

  GetOrdersUseCase(this._repository);

  Future<Result<List<OrderEntity>>> call({required String userId}) {
    return _repository.getUserOrders(userId);
  }
}
