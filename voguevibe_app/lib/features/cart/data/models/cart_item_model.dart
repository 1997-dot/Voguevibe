import '../../../../data/models/product_model.dart';
import '../../domain/entities/cart_item.dart';

/// Proxy model that extends CartItemEntity and delegates mutable fields
/// to the underlying legacy ProductModel, preserving shared state.
class CartItemModel extends CartItemEntity {
  final ProductModel _legacy;

  CartItemModel._(this._legacy)
      : super(
          id: _legacy.id,
          title: _legacy.title,
          description: _legacy.description,
          price: _legacy.price,
          category: _legacy.category,
          images: _legacy.images,
          thumbnail: _legacy.thumbnail,
          specifications: _legacy.specifications,
        );

  factory CartItemModel.fromLegacy(ProductModel legacy) =>
      CartItemModel._(legacy);

  @override
  bool get isFavorite => _legacy.isFavorite;

  @override
  set isFavorite(bool value) => _legacy.isFavorite = value;

  @override
  bool get isInCart => _legacy.isInCart;

  @override
  set isInCart(bool value) => _legacy.isInCart = value;

  @override
  int get cartQuantity => _legacy.cartQuantity;

  @override
  set cartQuantity(int value) => _legacy.cartQuantity = value;
}
