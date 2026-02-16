/// Favorite item entity — pure Dart, no framework imports.
/// Mutable fields (isFavorite, isInCart, cartQuantity) support shared state
/// across features via the proxy pattern in the data layer.
class FavoriteItemEntity {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final List<String> images;
  final String thumbnail;
  final Map<String, String> specifications;
  bool isFavorite;
  bool isInCart;
  int cartQuantity;

  FavoriteItemEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.images,
    required this.thumbnail,
    required this.specifications,
    this.isFavorite = false,
    this.isInCart = false,
    this.cartQuantity = 0,
  });
}
