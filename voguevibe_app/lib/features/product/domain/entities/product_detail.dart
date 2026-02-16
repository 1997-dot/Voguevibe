import 'product.dart';

/// Product detail entity for single-product detail view.
/// Extends ProductEntity — currently same fields, prepared for
/// future API split where detail endpoint returns more data.
class ProductDetailEntity extends ProductEntity {
  ProductDetailEntity({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.category,
    required super.images,
    required super.thumbnail,
    required super.specifications,
    super.isFavorite,
    super.isInCart,
    super.cartQuantity,
  });
}
