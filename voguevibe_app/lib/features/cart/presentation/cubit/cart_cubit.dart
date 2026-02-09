import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/repositories/product_repository.dart';
import '../../../../data/managers/user_data_manager.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final ProductRepository _repository = ProductRepository();
  final UserDataManager _userDataManager = UserDataManager();

  String? _currentUserId;

  CartCubit() : super(CartInitial());

  /// Set current user and load cart
  Future<void> setUser(String? userId) async {
    _currentUserId = userId;
    await loadCart();
  }

  /// Load cart items
  Future<void> loadCart() async {
    if (_currentUserId == null) {
      emit(CartLoaded(
        cartProducts: [],
        cartTotal: 0.0,
        cartItemsCount: 0,
      ));
      return;
    }

    emit(CartLoading());

    try {
      // Load cart data from storage
      final cart = await _userDataManager.getUserCart(_currentUserId!);

      // Update product models
      for (var product in _repository.getAllProducts()) {
        if (cart.containsKey(product.id)) {
          product.isInCart = true;
          product.cartQuantity = cart[product.id]!;
        } else {
          product.isInCart = false;
          product.cartQuantity = 0;
        }
      }

      final cartProducts = _repository.getCartProducts();
      final cartTotal = _repository.getCartTotal();
      final cartItemsCount = _repository.getCartItemsCount();

      emit(CartLoaded(
        cartProducts: cartProducts,
        cartTotal: cartTotal,
        cartItemsCount: cartItemsCount,
      ));
    } catch (e) {
      emit(CartError('Failed to load cart: ${e.toString()}'));
    }
  }

  /// Add product to cart
  Future<void> addToCart(String productId) async {
    if (_currentUserId == null) {
      emit(const CartError('Please login to add items to cart'));
      return;
    }

    try {
      _repository.addToCart(productId);
      final product = _repository.getProductById(productId);

      if (product != null) {
        await _userDataManager.updateCartQuantity(
          _currentUserId!,
          productId,
          product.cartQuantity,
        );
      }

      await loadCart();
    } catch (e) {
      emit(CartError('Failed to add to cart: ${e.toString()}'));
      await loadCart(); // Reload to show current state
    }
  }

  /// Remove product from cart
  Future<void> removeFromCart(String productId) async {
    if (_currentUserId == null) return;

    try {
      _repository.removeFromCart(productId);
      await _userDataManager.removeFromCart(_currentUserId!, productId);
      await loadCart();
    } catch (e) {
      emit(CartError('Failed to remove from cart: ${e.toString()}'));
      await loadCart();
    }
  }

  /// Update cart quantity
  Future<void> updateCartQuantity(String productId, int quantity) async {
    if (_currentUserId == null) return;

    try {
      _repository.updateCartQuantity(productId, quantity);
      await _userDataManager.updateCartQuantity(
        _currentUserId!,
        productId,
        quantity,
      );
      await loadCart();
    } catch (e) {
      emit(CartError('Failed to update quantity: ${e.toString()}'));
      await loadCart();
    }
  }

  /// Increment cart quantity
  Future<void> incrementQuantity(String productId) async {
    if (_currentUserId == null) return;

    try {
      _repository.incrementQuantity(productId);
      final product = _repository.getProductById(productId);

      if (product != null) {
        await _userDataManager.updateCartQuantity(
          _currentUserId!,
          productId,
          product.cartQuantity,
        );
      }

      await loadCart();
    } catch (e) {
      emit(CartError('Failed to increment quantity: ${e.toString()}'));
      await loadCart();
    }
  }

  /// Decrement cart quantity
  Future<void> decrementQuantity(String productId) async {
    if (_currentUserId == null) return;

    try {
      _repository.decrementQuantity(productId);
      final product = _repository.getProductById(productId);

      if (product != null) {
        if (product.isInCart) {
          await _userDataManager.updateCartQuantity(
            _currentUserId!,
            productId,
            product.cartQuantity,
          );
        } else {
          await _userDataManager.removeFromCart(_currentUserId!, productId);
        }
      }

      await loadCart();
    } catch (e) {
      emit(CartError('Failed to decrement quantity: ${e.toString()}'));
      await loadCart();
    }
  }

  /// Clear cart
  Future<void> clearCart() async {
    if (_currentUserId == null) return;

    try {
      _repository.clearCart();
      await _userDataManager.clearCart(_currentUserId!);
      await loadCart();
    } catch (e) {
      emit(CartError('Failed to clear cart: ${e.toString()}'));
      await loadCart();
    }
  }

  /// Check if product is in cart
  bool isInCart(String productId) {
    final product = _repository.getProductById(productId);
    return product?.isInCart ?? false;
  }

  /// Get product cart quantity
  int getCartQuantity(String productId) {
    final product = _repository.getProductById(productId);
    return product?.cartQuantity ?? 0;
  }
}
