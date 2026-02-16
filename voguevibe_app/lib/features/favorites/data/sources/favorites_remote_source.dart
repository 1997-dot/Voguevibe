import '../../../../core/utils/result.dart';
import '../../../../data/managers/user_data_manager.dart';
import '../../../../data/repositories/product_repository.dart';
import '../models/favorite_item_model.dart';

/// Data source that wraps legacy ProductRepository and UserDataManager
/// singletons, copying exact logic from the original FavoritesCubit.
class FavoritesDataSource {
  final ProductRepository _repository = ProductRepository();
  final UserDataManager _userDataManager = UserDataManager();

  /// Load favorites: hydrate isFavorite from persisted data, return list.
  Future<Result<List<FavoriteItemModel>>> loadFavorites(String userId) {
    return _tryAsync(() async {
      final favorites = await _userDataManager.getUserFavorites(userId);

      for (var product in _repository.getAllProducts()) {
        product.isFavorite = favorites.contains(product.id);
      }

      return _repository
          .getFavoriteProducts()
          .map((p) => FavoriteItemModel.fromLegacy(p))
          .toList();
    });
  }

  /// Toggle favorite in both repository and persistence.
  Future<Result<void>> toggleFavorite(String userId, String productId) {
    return _tryAsync(() async {
      _repository.toggleFavorite(productId);
      await _userDataManager.toggleFavorite(userId, productId);
    });
  }

  /// Sync lookup for a product by ID.
  FavoriteItemModel? getProductById(String productId) {
    final product = _repository.getProductById(productId);
    return product != null ? FavoriteItemModel.fromLegacy(product) : null;
  }

  /// Helper to wrap async operations in Result.
  Future<Result<T>> _tryAsync<T>(Future<T> Function() fn) async {
    try {
      final data = await fn();
      return Success(data);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
