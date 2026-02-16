import '../../../../data/models/product_model.dart';
import '../../domain/entities/product.dart';

/// Data model that bridges legacy ProductModel to domain ProductEntity.
/// Uses proxy pattern: delegates mutable fields to the underlying
/// ProductModel so shared state across cubits is preserved.
class ProductFeatureModel extends ProductEntity {
  final ProductModel _legacy;

  ProductFeatureModel._(this._legacy)
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

  factory ProductFeatureModel.fromLegacy(ProductModel legacy) {
    return ProductFeatureModel._(legacy);
  }

  // --- Proxy mutable fields to the underlying ProductModel ---

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

  // --- JSON serialization ---

  factory ProductFeatureModel.fromJson(Map<String, dynamic> json) {
    return ProductFeatureModel._(ProductModel.fromJson(json));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'images': images,
      'thumbnail': thumbnail,
      'specifications': specifications,
      'isFavorite': isFavorite,
      'isInCart': isInCart,
      'cartQuantity': cartQuantity,
    };
  }
}
