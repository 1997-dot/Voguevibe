import 'package:flutter/foundation.dart';
import '../data/models/product_model.dart';
import '../data/models/order_model.dart';
import '../data/repositories/product_repository.dart';
import '../data/managers/user_data_manager.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository = ProductRepository();
  final UserDataManager _userDataManager = UserDataManager();

  String? _currentUserId;

  /// Set current user ID (called after login)
  Future<void> setUser(String? userId) async {
    _currentUserId = userId;
    if (userId != null) {
      await _loadUserData(userId);
    } else {
      _clearUserState();
    }
    notifyListeners();
  }

  /// Load user-specific data
  Future<void> _loadUserData(String userId) async {
    // Load favorites
    final favorites = await _userDataManager.getUserFavorites(userId);
    for (var product in _repository.getAllProducts()) {
      product.isFavorite = favorites.contains(product.id);
    }

    // Load cart
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
  }

  /// Clear user state on logout
  void _clearUserState() {
    for (var product in _repository.getAllProducts()) {
      product.isFavorite = false;
      product.isInCart = false;
      product.cartQuantity = 0;
    }
  }

  /// Get all products
  List<ProductModel> get allProducts => _repository.getAllProducts();

  /// Get products by category
  List<ProductModel> getProductsByCategory(String category) {
    return _repository.getProductsByCategory(category);
  }

  /// Get favorite products
  List<ProductModel> get favoriteProducts => _repository.getFavoriteProducts();

  /// Get cart products
  List<ProductModel> get cartProducts => _repository.getCartProducts();

  /// Get product by ID
  ProductModel? getProductById(String id) {
    return _repository.getProductById(id);
  }

  /// Get cart total
  double get cartTotal => _repository.getCartTotal();

  /// Get cart items count
  int get cartItemsCount => _repository.getCartItemsCount();

  /// Get all categories
  List<String> get categories => _repository.getCategories();

  /// Toggle favorite status
  Future<void> toggleFavorite(String productId) async {
    if (_currentUserId == null) return;

    _repository.toggleFavorite(productId);
    await _userDataManager.toggleFavorite(_currentUserId!, productId);
    notifyListeners();
  }

  /// Add product to cart
  Future<void> addToCart(String productId) async {
    if (_currentUserId == null) return;

    _repository.addToCart(productId);
    final product = getProductById(productId);
    if (product != null) {
      await _userDataManager.updateCartQuantity(
        _currentUserId!,
        productId,
        product.cartQuantity,
      );
    }
    notifyListeners();
  }

  /// Remove product from cart
  Future<void> removeFromCart(String productId) async {
    if (_currentUserId == null) return;

    _repository.removeFromCart(productId);
    await _userDataManager.removeFromCart(_currentUserId!, productId);
    notifyListeners();
  }

  /// Update cart quantity
  Future<void> updateCartQuantity(String productId, int quantity) async {
    if (_currentUserId == null) return;

    _repository.updateCartQuantity(productId, quantity);
    await _userDataManager.updateCartQuantity(_currentUserId!, productId, quantity);
    notifyListeners();
  }

  /// Increment cart quantity
  Future<void> incrementQuantity(String productId) async {
    if (_currentUserId == null) return;

    _repository.incrementQuantity(productId);
    final product = getProductById(productId);
    if (product != null) {
      await _userDataManager.updateCartQuantity(
        _currentUserId!,
        productId,
        product.cartQuantity,
      );
    }
    notifyListeners();
  }

  /// Decrement cart quantity
  Future<void> decrementQuantity(String productId) async {
    if (_currentUserId == null) return;

    _repository.decrementQuantity(productId);
    final product = getProductById(productId);
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
    notifyListeners();
  }

  /// Clear cart
  Future<void> clearCart() async {
    if (_currentUserId == null) return;

    _repository.clearCart();
    await _userDataManager.clearCart(_currentUserId!);
    notifyListeners();
  }

  /// Create order from cart
  Future<OrderModel?> createOrder({
    String? shippingAddress,
    String? paymentMethod,
  }) async {
    if (_currentUserId == null) return null;

    final order = OrderModel.fromCartProducts(
      cartProducts: cartProducts,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
    );

    await _userDataManager.addOrder(_currentUserId!, order);
    await clearCart();

    return order;
  }

  /// Get user orders
  Future<List<OrderModel>> getUserOrders() async {
    if (_currentUserId == null) return [];
    return await _userDataManager.getUserOrders(_currentUserId!);
  }

  /// Check if product is in favorites
  bool isFavorite(String productId) {
    final product = getProductById(productId);
    return product?.isFavorite ?? false;
  }

  /// Check if product is in cart
  bool isInCart(String productId) {
    final product = getProductById(productId);
    return product?.isInCart ?? false;
  }

  /// Get product cart quantity
  int getCartQuantity(String productId) {
    final product = getProductById(productId);
    return product?.cartQuantity ?? 0;
  }
}
