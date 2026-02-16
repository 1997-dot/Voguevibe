import '../../../../core/utils/result.dart';
import '../repositories/favorites_repository.dart';

class ToggleFavoriteUseCase {
  final FavoritesFeatureRepository _repository;

  ToggleFavoriteUseCase(this._repository);

  Future<Result<void>> call({
    required String userId,
    required String productId,
  }) {
    return _repository.toggleFavorite(userId, productId);
  }
}
