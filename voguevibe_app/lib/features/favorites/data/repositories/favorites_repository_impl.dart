import '../../../../core/utils/result.dart';
import '../../domain/entities/favorite_item.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../sources/favorites_remote_source.dart';

class FavoritesRepositoryImpl implements FavoritesFeatureRepository {
  final FavoritesDataSource _dataSource;

  FavoritesRepositoryImpl({required FavoritesDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<Result<List<FavoriteItemEntity>>> loadFavorites(String userId) async {
    final result = await _dataSource.loadFavorites(userId);
    switch (result) {
      case Success(data: final favorites):
        return Success(List<FavoriteItemEntity>.from(favorites));
      case Failure(message: final msg):
        return Failure(msg);
    }
  }

  @override
  Future<Result<void>> toggleFavorite(String userId, String productId) {
    return _dataSource.toggleFavorite(userId, productId);
  }

  @override
  FavoriteItemEntity? getProductById(String productId) {
    return _dataSource.getProductById(productId);
  }
}
