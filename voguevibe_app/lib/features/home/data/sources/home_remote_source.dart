import '../../../../core/utils/result.dart';
import '../../../../data/managers/user_data_manager.dart';
import '../../../../data/repositories/product_repository.dart';
import '../models/home_section_model.dart';

/// Data source that wraps legacy ProductRepository and UserDataManager singletons.
class HomeDataSource {
  final ProductRepository _productRepository = ProductRepository();
  final UserDataManager _userDataManager = UserDataManager();

  /// Get all products as HomeProductModel proxies wrapping the singleton objects
  Result<List<HomeProductModel>> getProducts() {
    try {
      final products = _productRepository.getAllProducts();
      final proxied = products
          .map((p) => HomeProductModel.fromLegacy(p))
          .toList();
      return Success(proxied);
    } catch (e) {
      return Failure('Failed to load products: ${e.toString()}');
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

  /// Load user-specific data (favorites, cart) and hydrate product objects.
  /// Logic moved from HomeCubit._loadUserData().
  Future<Result<void>> loadUserData(String userId) async {
    try {
      // Load favorites
      final favorites = await _userDataManager.getUserFavorites(userId);
      for (var product in _productRepository.getAllProducts()) {
        product.isFavorite = favorites.contains(product.id);
      }

      // Load cart
      final cart = await _userDataManager.getUserCart(userId);
      for (var product in _productRepository.getAllProducts()) {
        if (cart.containsKey(product.id)) {
          product.isInCart = true;
          product.cartQuantity = cart[product.id]!;
        } else {
          product.isInCart = false;
          product.cartQuantity = 0;
        }
      }

      return const Success(null);
    } catch (e) {
      return Failure('Failed to load user data: ${e.toString()}');
    }
  }

  /// Clear user context — reset mutable state on all products
  void clearUserContext() {
    for (var product in _productRepository.getAllProducts()) {
      product.isFavorite = false;
      product.isInCart = false;
      product.cartQuantity = 0;
    }
  }
}
