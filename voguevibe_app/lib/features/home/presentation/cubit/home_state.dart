import 'package:equatable/equatable.dart';
import '../../../../data/models/product_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class HomeInitial extends HomeState {}

/// Loading state
class HomeLoading extends HomeState {}

/// Loaded state with products and categories
class HomeLoaded extends HomeState {
  final List<ProductModel> allProducts;
  final List<String> categories;

  const HomeLoaded({
    required this.allProducts,
    required this.categories,
  });

  @override
  List<Object?> get props => [allProducts, categories];

  /// Get products by category
  List<ProductModel> getProductsByCategory(String category) {
    return allProducts.where((p) => p.category == category).toList();
  }

  /// Get favorite products
  List<ProductModel> get favoriteProducts {
    return allProducts.where((p) => p.isFavorite).toList();
  }
}

/// Error state
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
