import '../../../../core/utils/result.dart';
import '../entities/favorite_item.dart';
import '../repositories/favorites_repository.dart';

class GetFavoritesUseCase {
  final FavoritesFeatureRepository _repository;

  GetFavoritesUseCase(this._repository);

  Future<Result<List<FavoriteItemEntity>>> call({required String userId}) {
    return _repository.loadFavorites(userId);
  }
}
