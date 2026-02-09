import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';

/// Manages user-specific data (favorites, cart, orders)
/// Each user has their own isolated data
class UserDataManager {
  static final UserDataManager _instance = UserDataManager._internal();
  factory UserDataManager() => _instance;
  UserDataManager._internal();

  // Keys for storing user data
  static const String _favoritesPrefix = 'user_favorites_';
  static const String _cartPrefix = 'user_cart_';
  static const String _ordersPrefix = 'user_orders_';

  /// Get user's favorite product IDs
  Future<Set<String>> getUserFavorites(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString('$_favoritesPrefix$userId');

      if (favoritesJson != null) {
        final List<dynamic> favoritesList = json.decode(favoritesJson);
        return favoritesList.map((id) => id.toString()).toSet();
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  /// Save user's favorites
  Future<void> saveUserFavorites(String userId, Set<String> favoriteIds) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = json.encode(favoriteIds.toList());
      await prefs.setString('$_favoritesPrefix$userId', favoritesJson);
    } catch (e) {
      throw Exception('Failed to save favorites: ${e.toString()}');
    }
  }

  /// Toggle favorite for user
  Future<Set<String>> toggleFavorite(String userId, String productId) async {
    final favorites = await getUserFavorites(userId);

    if (favorites.contains(productId)) {
      favorites.remove(productId);
    } else {
      favorites.add(productId);
    }

    await saveUserFavorites(userId, favorites);
    return favorites;
  }

  /// Get user's cart data (productId -> quantity)
  Future<Map<String, int>> getUserCart(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString('$_cartPrefix$userId');

      if (cartJson != null) {
        final Map<String, dynamic> cartData = json.decode(cartJson);
        return cartData.map((key, value) => MapEntry(key, value as int));
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  /// Save user's cart
  Future<void> saveUserCart(String userId, Map<String, int> cart) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = json.encode(cart);
      await prefs.setString('$_cartPrefix$userId', cartJson);
    } catch (e) {
      throw Exception('Failed to save cart: ${e.toString()}');
    }
  }

  /// Add item to user's cart
  Future<Map<String, int>> addToCart(String userId, String productId, int quantity) async {
    final cart = await getUserCart(userId);
    cart[productId] = (cart[productId] ?? 0) + quantity;
    await saveUserCart(userId, cart);
    return cart;
  }

  /// Remove item from user's cart
  Future<Map<String, int>> removeFromCart(String userId, String productId) async {
    final cart = await getUserCart(userId);
    cart.remove(productId);
    await saveUserCart(userId, cart);
    return cart;
  }

  /// Update cart item quantity
  Future<Map<String, int>> updateCartQuantity(
    String userId,
    String productId,
    int quantity,
  ) async {
    final cart = await getUserCart(userId);

    if (quantity > 0) {
      cart[productId] = quantity;
    } else {
      cart.remove(productId);
    }

    await saveUserCart(userId, cart);
    return cart;
  }

  /// Clear user's cart
  Future<void> clearCart(String userId) async {
    await saveUserCart(userId, {});
  }

  /// Get user's orders
  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = prefs.getString('$_ordersPrefix$userId');

      if (ordersJson != null) {
        final List<dynamic> ordersList = json.decode(ordersJson);
        return ordersList.map((json) => OrderModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Save user's orders
  Future<void> saveUserOrders(String userId, List<OrderModel> orders) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = json.encode(orders.map((order) => order.toJson()).toList());
      await prefs.setString('$_ordersPrefix$userId', ordersJson);
    } catch (e) {
      throw Exception('Failed to save orders: ${e.toString()}');
    }
  }

  /// Add order for user
  Future<void> addOrder(String userId, OrderModel order) async {
    final orders = await getUserOrders(userId);
    orders.insert(0, order); // Add at beginning (most recent first)
    await saveUserOrders(userId, orders);
  }

  /// Clear all user data (on logout)
  Future<void> clearUserData(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_favoritesPrefix$userId');
      await prefs.remove('$_cartPrefix$userId');
      await prefs.remove('$_ordersPrefix$userId');
    } catch (e) {
      throw Exception('Failed to clear user data: ${e.toString()}');
    }
  }
}
