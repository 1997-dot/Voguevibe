import '../../../../core/utils/result.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../sources/cart_remote_source.dart';

class CartRepositoryImpl implements CartFeatureRepository {
  final CartDataSource _dataSource;

  CartRepositoryImpl({required CartDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<Result<CartEntity>> loadCart(String userId) async {
    final result = await _dataSource.loadCart(userId);
    switch (result) {
      case Success(data: final cartData):
        return Success(CartEntity(
          items: List<CartItemEntity>.from(cartData.items),
          total: cartData.total,
          itemsCount: cartData.itemsCount,
        ));
      case Failure(message: final msg):
        return Failure(msg);
    }
  }

  @override
  Future<Result<void>> addToCart(String userId, String productId) {
    return _dataSource.addToCart(userId, productId);
  }

  @override
  Future<Result<void>> removeFromCart(String userId, String productId) {
    return _dataSource.removeFromCart(userId, productId);
  }

  @override
  Future<Result<void>> updateQuantity(
      String userId, String productId, int quantity) {
    return _dataSource.updateQuantity(userId, productId, quantity);
  }

  @override
  Future<Result<void>> incrementQuantity(String userId, String productId) {
    return _dataSource.incrementQuantity(userId, productId);
  }

  @override
  Future<Result<void>> decrementQuantity(String userId, String productId) {
    return _dataSource.decrementQuantity(userId, productId);
  }

  @override
  Future<Result<void>> clearCart(String userId) {
    return _dataSource.clearCart(userId);
  }

  @override
  CartItemEntity? getProductById(String productId) {
    return _dataSource.getProductById(productId);
  }
}
