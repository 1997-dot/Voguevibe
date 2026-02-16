import '../../../../core/utils/result.dart';
import '../entities/favorite_item.dart';

/// Abstract contract for the favorites feature repository.
abstract class FavoritesFeatureRepository {
  Future<Result<List<FavoriteItemEntity>>> loadFavorites(String userId);
  Future<Result<void>> toggleFavorite(String userId, String productId);
  FavoriteItemEntity? getProductById(String productId);
}
