import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ProductsInitial extends ProductsState {}

/// Loading state
class ProductsLoading extends ProductsState {}

/// Loaded state with products and categories
class ProductsLoaded extends ProductsState {
  final List<ProductEntity> products;
  final List<String> categories;
  final String? selectedCategory;

  const ProductsLoaded({
    required this.products,
    required this.categories,
    this.selectedCategory,
  });

  @override
  List<Object?> get props => [products, categories, selectedCategory];

  /// Get products filtered by category
  List<ProductEntity> getProductsByCategory(String category) {
    return products.where((p) => p.category == category).toList();
  }

  /// Check if list is empty
  bool get isEmpty => products.isEmpty;
}

/// Error state
class ProductsError extends ProductsState {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object?> get props => [message];
}
