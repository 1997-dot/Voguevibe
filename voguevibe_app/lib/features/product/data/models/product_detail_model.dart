import '../../../../data/models/product_model.dart';
import '../../domain/entities/product_detail.dart';

/// Data model for product detail view.
/// Same proxy pattern — delegates mutable fields to legacy ProductModel.
class ProductDetailFeatureModel extends ProductDetailEntity {
  final ProductModel _legacy;

  ProductDetailFeatureModel._(this._legacy)
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

  factory ProductDetailFeatureModel.fromLegacy(ProductModel legacy) {
    return ProductDetailFeatureModel._(legacy);
  }

  // --- Proxy mutable fields ---

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
