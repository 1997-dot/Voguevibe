import '../../../../core/utils/result.dart';
import '../repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartFeatureRepository _repository;

  AddToCartUseCase(this._repository);

  Future<Result<void>> call({
    required String userId,
    required String productId,
  }) {
    return _repository.addToCart(userId, productId);
  }
}
