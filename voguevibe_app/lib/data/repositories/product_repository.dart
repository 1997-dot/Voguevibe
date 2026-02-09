import '../models/product_model.dart';
import '../mock_data/products_data.dart';

class ProductRepository {
  // Singleton pattern to ensure single source of truth
  static final ProductRepository _instance = ProductRepository._internal();
  factory ProductRepository() => _instance;
  ProductRepository._internal();

  // Single source of truth - all products
  final List<ProductModel> _products = allProducts;

  /// Get all products
  List<ProductModel> getAllProducts() {
    return _products;
  }

  /// Get products by category
  List<ProductModel> getProductsByCategory(String category) {
    return _products.where((product) => product.category.toLowerCase() == category.toLowerCase()).toList();
  }

  /// Get all favorite products
  List<ProductModel> getFavoriteProducts() {
    return _products.where((product) => product.isFavorite).toList();
  }

  /// Get all cart products
  List<ProductModel> getCartProducts() {
    return _products.where((product) => product.isInCart && product.cartQuantity > 0).toList();
  }

  /// Get product by ID
  ProductModel? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Toggle favorite status
  void toggleFavorite(String productId) {
    final product = getProductById(productId);
    if (product != null) {
      product.isFavorite = !product.isFavorite;
    }
  }

  /// Add product to cart
  void addToCart(String productId) {
    final product = getProductById(productId);
    if (product != null) {
      product.isInCart = true;
      if (product.cartQuantity == 0) {
        product.cartQuantity = 1;
      }
    }
  }

  /// Remove product from cart
  void removeFromCart(String productId) {
    final product = getProductById(productId);
    if (product != null) {
      product.isInCart = false;
      product.cartQuantity = 0;
    }
  }

  /// Update cart quantity
  void updateCartQuantity(String productId, int quantity) {
    final product = getProductById(productId);
    if (product != null) {
      if (quantity > 0) {
        product.cartQuantity = quantity;
        product.isInCart = true;
      } else {
        product.cartQuantity = 0;
        product.isInCart = false;
      }
    }
  }

  /// Increment cart quantity
  void incrementQuantity(String productId) {
    final product = getProductById(productId);
    if (product != null) {
      product.cartQuantity++;
      product.isInCart = true;
    }
  }

  /// Decrement cart quantity
  void decrementQuantity(String productId) {
    final product = getProductById(productId);
    if (product != null) {
      if (product.cartQuantity > 1) {
        product.cartQuantity--;
      } else {
        removeFromCart(productId);
      }
    }
  }

  /// Get cart total price
  double getCartTotal() {
    return _products
        .where((product) => product.isInCart && product.cartQuantity > 0)
        .fold(0.0, (sum, product) => sum + (product.price * product.cartQuantity));
  }

  /// Get cart items count
  int getCartItemsCount() {
    return _products
        .where((product) => product.isInCart && product.cartQuantity > 0)
        .fold(0, (sum, product) => sum + product.cartQuantity);
  }

  /// Clear all cart items
  void clearCart() {
    for (var product in _products) {
      product.isInCart = false;
      product.cartQuantity = 0;
    }
  }

  /// Get all available categories
  List<String> getCategories() {
    return _products.map((product) => product.category).toSet().toList();
  }
}
