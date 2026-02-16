import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/usecases/get_favorites_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesFeatureRepository _favoritesRepository;
  final GetFavoritesUseCase _getFavoritesUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;

  String? _currentUserId;

  FavoritesCubit({
    required FavoritesFeatureRepository favoritesRepository,
    required GetFavoritesUseCase getFavoritesUseCase,
    required ToggleFavoriteUseCase toggleFavoriteUseCase,
  })  : _favoritesRepository = favoritesRepository,
        _getFavoritesUseCase = getFavoritesUseCase,
        _toggleFavoriteUseCase = toggleFavoriteUseCase,
        super(FavoritesInitial());

  /// Set current user and load favorites
  Future<void> setUser(String? userId) async {
    _currentUserId = userId;
    await loadFavorites();
  }

  /// Load favorite products
  Future<void> loadFavorites() async {
    if (_currentUserId == null) {
      emit(const FavoritesLoaded(favoriteProducts: []));
      return;
    }

    emit(FavoritesLoading());

    final result = await _getFavoritesUseCase(userId: _currentUserId!);
    switch (result) {
      case Success(data: final favorites):
        emit(FavoritesLoaded(favoriteProducts: favorites));
      case Failure(message: final msg):
        emit(FavoritesError('Failed to load favorites: $msg'));
    }
  }

  /// Toggle favorite status for a product
  Future<void> toggleFavorite(String productId) async {
    if (_currentUserId == null) {
      emit(const FavoritesError('Please login to add favorites'));
      return;
    }

    final result = await _toggleFavoriteUseCase(
        userId: _currentUserId!, productId: productId);
    switch (result) {
      case Success():
        await loadFavorites();
      case Failure(message: final msg):
        emit(FavoritesError('Failed to toggle favorite: $msg'));
        await loadFavorites();
    }
  }

  /// Check if product is favorite
  bool isFavorite(String productId) {
    final product = _favoritesRepository.getProductById(productId);
    return product?.isFavorite ?? false;
  }
}
