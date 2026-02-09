import 'package:equatable/equatable.dart';
import '../../../../data/models/product_model.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class FavoritesInitial extends FavoritesState {}

/// Loading state
class FavoritesLoading extends FavoritesState {}

/// Loaded state with favorite products
class FavoritesLoaded extends FavoritesState {
  final List<ProductModel> favoriteProducts;

  const FavoritesLoaded({required this.favoriteProducts});

  @override
  List<Object?> get props => [favoriteProducts];

  /// Check if favorites list is empty
  bool get isEmpty => favoriteProducts.isEmpty;

  /// Get favorite product by ID
  ProductModel? getProductById(String productId) {
    try {
      return favoriteProducts.firstWhere((p) => p.id == productId);
    } catch (e) {
      return null;
    }
  }

  /// Check if product is in favorites
  bool isFavorite(String productId) {
    return favoriteProducts.any((p) => p.id == productId);
  }
}

/// Error state
class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}
