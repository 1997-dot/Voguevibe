import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/repositories/product_repository.dart';
import '../../../../data/managers/user_data_manager.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final ProductRepository _repository = ProductRepository();
  final UserDataManager _userDataManager = UserDataManager();

  String? _currentUserId;

  FavoritesCubit() : super(FavoritesInitial());

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

    try {
      // Load favorites from storage
      final favorites = await _userDataManager.getUserFavorites(_currentUserId!);

      // Update product models
      for (var product in _repository.getAllProducts()) {
        product.isFavorite = favorites.contains(product.id);
      }

      final favoriteProducts = _repository.getFavoriteProducts();

      emit(FavoritesLoaded(favoriteProducts: favoriteProducts));
    } catch (e) {
      emit(FavoritesError('Failed to load favorites: ${e.toString()}'));
    }
  }

  /// Toggle favorite status for a product
  Future<void> toggleFavorite(String productId) async {
    if (_currentUserId == null) {
      emit(const FavoritesError('Please login to add favorites'));
      return;
    }

    try {
      // Toggle in repository
      _repository.toggleFavorite(productId);

      // Toggle in storage
      await _userDataManager.toggleFavorite(_currentUserId!, productId);

      // Reload favorites
      await loadFavorites();
    } catch (e) {
      emit(FavoritesError('Failed to toggle favorite: ${e.toString()}'));
      await loadFavorites(); // Reload to show current state
    }
  }

  /// Check if product is favorite
  bool isFavorite(String productId) {
    final product = _repository.getProductById(productId);
    return product?.isFavorite ?? false;
  }
}
