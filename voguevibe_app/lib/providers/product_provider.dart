import 'package:flutter/foundation.dart';
import '../data/models/product_model.dart';
import '../data/repositories/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository = ProductRepository();

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
  void toggleFavorite(String productId) {
    _repository.toggleFavorite(productId);
    notifyListeners();
  }

  /// Add product to cart
  void addToCart(String productId) {
    _repository.addToCart(productId);
    notifyListeners();
  }

  /// Remove product from cart
  void removeFromCart(String productId) {
    _repository.removeFromCart(productId);
    notifyListeners();
  }

  /// Update cart quantity
  void updateCartQuantity(String productId, int quantity) {
    _repository.updateCartQuantity(productId, quantity);
    notifyListeners();
  }

  /// Increment cart quantity
  void incrementQuantity(String productId) {
    _repository.incrementQuantity(productId);
    notifyListeners();
  }

  /// Decrement cart quantity
  void decrementQuantity(String productId) {
    _repository.decrementQuantity(productId);
    notifyListeners();
  }

  /// Clear cart
  void clearCart() {
    _repository.clearCart();
    notifyListeners();
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
