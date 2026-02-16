import '../../../../core/utils/result.dart';
import '../../../../data/repositories/product_repository.dart';
import '../models/product_detail_model.dart';
import '../models/product_model.dart';

/// Data source that wraps the legacy ProductRepository singleton.
class ProductDataSource {
  final ProductRepository _productRepository = ProductRepository();

  /// Get all products as ProductFeatureModel proxies
  Result<List<ProductFeatureModel>> getProducts() {
    try {
      final products = _productRepository.getAllProducts();
      final proxied = products
          .map((p) => ProductFeatureModel.fromLegacy(p))
          .toList();
      return Success(proxied);
    } catch (e) {
      return Failure('Failed to load products: ${e.toString()}');
    }
  }

  /// Get products filtered by category
  Result<List<ProductFeatureModel>> getProductsByCategory(String category) {
    try {
      final products = _productRepository.getProductsByCategory(category);
      final proxied = products
          .map((p) => ProductFeatureModel.fromLegacy(p))
          .toList();
      return Success(proxied);
    } catch (e) {
      return Failure('Failed to load products by category: ${e.toString()}');
    }
  }

  /// Get a single product by ID
  Result<ProductDetailFeatureModel> getProductById(String id) {
    try {
      final product = _productRepository.getProductById(id);
      if (product != null) {
        return Success(ProductDetailFeatureModel.fromLegacy(product));
      }
      return const Failure('Product not found');
    } catch (e) {
      return Failure('Failed to load product: ${e.toString()}');
    }
  }

  /// Get all available categories
  Result<List<String>> getCategories() {
    try {
      final categories = _productRepository.getCategories();
      return Success(categories);
    } catch (e) {
      return Failure('Failed to load categories: ${e.toString()}');
    }
  }
}
