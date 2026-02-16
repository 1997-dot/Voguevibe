import 'package:equatable/equatable.dart';
import '../../domain/entities/product_detail.dart';

abstract class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ProductDetailInitial extends ProductDetailState {}

/// Loading state
class ProductDetailLoading extends ProductDetailState {}

/// Loaded state with product detail
class ProductDetailLoaded extends ProductDetailState {
  final ProductDetailEntity product;

  const ProductDetailLoaded({required this.product});

  @override
  List<Object?> get props => [product];
}

/// Error state
class ProductDetailError extends ProductDetailState {
  final String message;

  const ProductDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
