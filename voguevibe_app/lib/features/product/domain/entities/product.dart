/// Product entity for the product feature domain layer.
/// Mutable fields (isFavorite, isInCart, cartQuantity) are required
/// because the ProductRepository singleton shares mutable objects
/// across Cart, Favorites, Home, and Product cubits.
class ProductEntity {
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

  ProductEntity({
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
