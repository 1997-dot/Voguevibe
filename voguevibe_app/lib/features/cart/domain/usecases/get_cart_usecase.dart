import '../../../../core/utils/result.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class GetCartUseCase {
  final CartFeatureRepository _repository;

  GetCartUseCase(this._repository);

  Future<Result<CartEntity>> call({required String userId}) {
    return _repository.loadCart(userId);
  }
}
