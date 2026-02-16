import '../../../../core/utils/result.dart';
import '../../../../data/managers/user_data_manager.dart';
import '../../../../data/repositories/product_repository.dart';
import '../models/cart_model.dart';
import '../models/cart_item_model.dart';

/// Data source that wraps legacy ProductRepository and UserDataManager
/// singletons, copying exact logic from the original CartCubit.
class CartDataSource {
  final ProductRepository _repository = ProductRepository();
  final UserDataManager _userDataManager = UserDataManager();

  /// Load cart: hydrate product models from persisted data, return cart data.
  Future<Result<CartDataModel>> loadCart(String userId) {
    return _tryAsync(() async {
      final cart = await _userDataManager.getUserCart(userId);

      for (var product in _repository.getAllProducts()) {
        if (cart.containsKey(product.id)) {
          product.isInCart = true;
          product.cartQuantity = cart[product.id]!;
        } else {
          product.isInCart = false;
          product.cartQuantity = 0;
        }
      }

      final cartProducts = _repository
          .getCartProducts()
          .map((p) => CartItemModel.fromLegacy(p))
          .toList();
      final cartTotal = _repository.getCartTotal();
      final cartItemsCount = _repository.getCartItemsCount();

      return CartDataModel(
        items: cartProducts,
        total: cartTotal,
        itemsCount: cartItemsCount,
      );
    });
  }

  /// Add product to cart in both repository and persistence.
  Future<Result<void>> addToCart(String userId, String productId) {
    return _tryAsync(() async {
      _repository.addToCart(productId);
      final product = _repository.getProductById(productId);
      if (product != null) {
        await _userDataManager.updateCartQuantity(
          userId,
          productId,
          product.cartQuantity,
        );
      }
    });
  }

  /// Remove product from cart in both layers.
  Future<Result<void>> removeFromCart(String userId, String productId) {
    return _tryAsync(() async {
      _repository.removeFromCart(productId);
      await _userDataManager.removeFromCart(userId, productId);
    });
  }

  /// Update cart quantity in both layers.
  Future<Result<void>> updateQuantity(
      String userId, String productId, int quantity) {
    return _tryAsync(() async {
      _repository.updateCartQuantity(productId, quantity);
      await _userDataManager.updateCartQuantity(userId, productId, quantity);
    });
  }

  /// Increment cart quantity in both layers.
  Future<Result<void>> incrementQuantity(String userId, String productId) {
    return _tryAsync(() async {
      _repository.incrementQuantity(productId);
      final product = _repository.getProductById(productId);
      if (product != null) {
        await _userDataManager.updateCartQuantity(
          userId,
          productId,
          product.cartQuantity,
        );
      }
    });
  }

  /// Decrement cart quantity in both layers.
  Future<Result<void>> decrementQuantity(String userId, String productId) {
    return _tryAsync(() async {
      _repository.decrementQuantity(productId);
      final product = _repository.getProductById(productId);
      if (product != null) {
        if (product.isInCart) {
          await _userDataManager.updateCartQuantity(
            userId,
            productId,
            product.cartQuantity,
          );
        } else {
          await _userDataManager.removeFromCart(userId, productId);
        }
      }
    });
  }

  /// Clear all cart items in both layers.
  Future<Result<void>> clearCart(String userId) {
    return _tryAsync(() async {
      _repository.clearCart();
      await _userDataManager.clearCart(userId);
    });
  }

  /// Sync lookup for a product by ID.
  CartItemModel? getProductById(String productId) {
    final product = _repository.getProductById(productId);
    return product != null ? CartItemModel.fromLegacy(product) : null;
  }

  /// Helper to wrap async operations in Result.
  Future<Result<T>> _tryAsync<T>(Future<T> Function() fn) async {
    try {
      final data = await fn();
      return Success(data);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
