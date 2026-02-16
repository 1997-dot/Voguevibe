import '../../../../data/models/product_model.dart';
import '../../domain/entities/home_section.dart';

/// Data model that bridges legacy ProductModel to domain Product entity.
/// Uses a proxy pattern: holds a reference to the underlying ProductModel
/// and delegates mutable field access (isFavorite, isInCart, cartQuantity)
/// so that shared mutable state across Cart/Favorites/Home cubits is preserved.
class HomeProductModel extends Product {
  final ProductModel _legacy;

  HomeProductModel._(this._legacy)
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

  /// Create a proxy wrapping a legacy ProductModel instance.
  /// Mutable fields (isFavorite, isInCart, cartQuantity) are delegated
  /// to the underlying ProductModel so mutations from other cubits
  /// are visible when home_page rebuilds.
  factory HomeProductModel.fromLegacy(ProductModel legacy) {
    return HomeProductModel._(legacy);
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

  // --- JSON serialization (for completeness) ---

  factory HomeProductModel.fromJson(Map<String, dynamic> json) {
    return HomeProductModel._(ProductModel.fromJson(json));
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
