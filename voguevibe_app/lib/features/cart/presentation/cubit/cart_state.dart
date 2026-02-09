import 'package:equatable/equatable.dart';
import '../../../../data/models/product_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CartInitial extends CartState {}

/// Loading state
class CartLoading extends CartState {}

/// Loaded state with cart items and totals
class CartLoaded extends CartState {
  final List<ProductModel> cartProducts;
  final double cartTotal;
  final int cartItemsCount;

  const CartLoaded({
    required this.cartProducts,
    required this.cartTotal,
    required this.cartItemsCount,
  });

  @override
  List<Object?> get props => [cartProducts, cartTotal, cartItemsCount];

  /// Check if cart is empty
  bool get isEmpty => cartProducts.isEmpty;

  /// Get product from cart by ID
  ProductModel? getProductById(String productId) {
    try {
      return cartProducts.firstWhere((p) => p.id == productId);
    } catch (e) {
      return null;
    }
  }

  /// Get quantity for specific product
  int getQuantity(String productId) {
    final product = getProductById(productId);
    return product?.cartQuantity ?? 0;
  }
}

/// Error state
class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Success state for operations (add/remove/update)
class CartOperationSuccess extends CartState {
  final String message;

  const CartOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
