import '../../../../core/utils/result.dart';
import '../entities/home_section.dart';

abstract class HomeRepository {
  /// Get all products
  Future<Result<List<Product>>> getProducts();

  /// Get all available categories
  Future<Result<List<String>>> getCategories();

  /// Load user-specific data (favorites, cart) and hydrate product objects
  Future<Result<void>> loadUserData(String userId);

  /// Clear user context — reset mutable state on all products
  void clearUserContext();
}
