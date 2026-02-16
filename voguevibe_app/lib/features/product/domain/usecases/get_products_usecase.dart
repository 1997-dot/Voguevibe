import '../../../../core/utils/result.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductFeatureRepository _repository;

  GetProductsUseCase(this._repository);

  /// Get products, optionally filtered by category.
  Future<Result<List<ProductEntity>>> call({String? category}) async {
    if (category != null) {
      return _repository.getProductsByCategory(category);
    }
    return _repository.getAllProducts();
  }
}
