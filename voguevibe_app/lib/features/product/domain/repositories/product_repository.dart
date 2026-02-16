import '../../../../core/utils/result.dart';
import '../entities/product.dart';
import '../entities/product_detail.dart';

abstract class ProductFeatureRepository {
  /// Get all products
  Future<Result<List<ProductEntity>>> getAllProducts();

  /// Get products filtered by category
  Future<Result<List<ProductEntity>>> getProductsByCategory(String category);

  /// Get a single product by ID
  Future<Result<ProductDetailEntity>> getProductById(String id);

  /// Get all available categories
  Future<Result<List<String>>> getCategories();
}
