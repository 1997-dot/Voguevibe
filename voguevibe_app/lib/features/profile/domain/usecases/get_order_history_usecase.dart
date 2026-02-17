import '../../../../core/utils/result.dart';
import '../entities/order.dart';
import '../repositories/profile_repository.dart';

class GetOrderHistoryUseCase {
  final ProfileRepository repository;

  GetOrderHistoryUseCase(this.repository);

  Future<Result<List<Order>>> call({required String userId}) async {
    return await repository.getOrderHistory(userId);
  }
}
