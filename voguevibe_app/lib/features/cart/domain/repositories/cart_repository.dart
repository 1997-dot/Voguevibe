import '../../../../core/utils/result.dart';
import '../entities/cart.dart';
import '../entities/cart_item.dart';

/// Abstract contract for the cart feature repository.
abstract class CartFeatureRepository {
  Future<Result<CartEntity>> loadCart(String userId);
  Future<Result<void>> addToCart(String userId, String productId);
  Future<Result<void>> removeFromCart(String userId, String productId);
  Future<Result<void>> updateQuantity(
      String userId, String productId, int quantity);
  Future<Result<void>> incrementQuantity(String userId, String productId);
  Future<Result<void>> decrementQuantity(String userId, String productId);
  Future<Result<void>> clearCart(String userId);
  CartItemEntity? getProductById(String productId);
}
