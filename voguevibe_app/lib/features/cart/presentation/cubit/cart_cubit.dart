import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartFeatureRepository _cartRepository;
  final GetCartUseCase _getCartUseCase;
  final AddToCartUseCase _addToCartUseCase;

  String? _currentUserId;

  CartCubit({
    required CartFeatureRepository cartRepository,
    required GetCartUseCase getCartUseCase,
    required AddToCartUseCase addToCartUseCase,
  })  : _cartRepository = cartRepository,
        _getCartUseCase = getCartUseCase,
        _addToCartUseCase = addToCartUseCase,
        super(CartInitial());

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

    final result = await _getCartUseCase(userId: _currentUserId!);
    switch (result) {
      case Success(data: final cart):
        emit(CartLoaded(
          cartProducts: cart.items,
          cartTotal: cart.total,
          cartItemsCount: cart.itemsCount,
        ));
      case Failure(message: final msg):
        emit(CartError('Failed to load cart: $msg'));
    }
  }

  /// Add product to cart
  Future<void> addToCart(String productId) async {
    if (_currentUserId == null) {
      emit(const CartError('Please login to add items to cart'));
      return;
    }

    final result = await _addToCartUseCase(
        userId: _currentUserId!, productId: productId);
    switch (result) {
      case Success():
        await loadCart();
      case Failure(message: final msg):
        emit(CartError('Failed to add to cart: $msg'));
        await loadCart();
    }
  }

  /// Remove product from cart
  Future<void> removeFromCart(String productId) async {
    if (_currentUserId == null) return;

    final result =
        await _cartRepository.removeFromCart(_currentUserId!, productId);
    switch (result) {
      case Success():
        await loadCart();
      case Failure(message: final msg):
        emit(CartError('Failed to remove from cart: $msg'));
        await loadCart();
    }
  }

  /// Update cart quantity
  Future<void> updateCartQuantity(String productId, int quantity) async {
    if (_currentUserId == null) return;

    final result = await _cartRepository.updateQuantity(
        _currentUserId!, productId, quantity);
    switch (result) {
      case Success():
        await loadCart();
      case Failure(message: final msg):
        emit(CartError('Failed to update quantity: $msg'));
        await loadCart();
    }
  }

  /// Increment cart quantity
  Future<void> incrementQuantity(String productId) async {
    if (_currentUserId == null) return;

    final result =
        await _cartRepository.incrementQuantity(_currentUserId!, productId);
    switch (result) {
      case Success():
        await loadCart();
      case Failure(message: final msg):
        emit(CartError('Failed to increment quantity: $msg'));
        await loadCart();
    }
  }

  /// Decrement cart quantity
  Future<void> decrementQuantity(String productId) async {
    if (_currentUserId == null) return;

    final result =
        await _cartRepository.decrementQuantity(_currentUserId!, productId);
    switch (result) {
      case Success():
        await loadCart();
      case Failure(message: final msg):
        emit(CartError('Failed to decrement quantity: $msg'));
        await loadCart();
    }
  }

  /// Clear cart
  Future<void> clearCart() async {
    if (_currentUserId == null) return;

    final result = await _cartRepository.clearCart(_currentUserId!);
    switch (result) {
      case Success():
        await loadCart();
      case Failure(message: final msg):
        emit(CartError('Failed to clear cart: $msg'));
        await loadCart();
    }
  }

  /// Check if product is in cart
  bool isInCart(String productId) {
    final product = _cartRepository.getProductById(productId);
    return product?.isInCart ?? false;
  }

  /// Get product cart quantity
  int getCartQuantity(String productId) {
    final product = _cartRepository.getProductById(productId);
    return product?.cartQuantity ?? 0;
  }
}
