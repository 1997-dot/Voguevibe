import '../../../../core/utils/result.dart';
import '../entities/product_detail.dart';
import '../repositories/product_repository.dart';

class GetProductDetailUseCase {
  final ProductFeatureRepository _repository;

  GetProductDetailUseCase(this._repository);

  /// Get a single product's full details by ID.
  Future<Result<ProductDetailEntity>> call({required String productId}) async {
    return _repository.getProductById(productId);
  }
}
