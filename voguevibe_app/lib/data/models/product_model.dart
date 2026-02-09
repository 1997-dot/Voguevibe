class ProductModel {
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

  ProductModel({
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

  // JSON Serialization
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

  // JSON Deserialization
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      images: List<String>.from(json['images'] as List),
      thumbnail: json['thumbnail'] as String,
      specifications: Map<String, String>.from(json['specifications'] as Map),
      isFavorite: json['isFavorite'] as bool? ?? false,
      isInCart: json['isInCart'] as bool? ?? false,
      cartQuantity: json['cartQuantity'] as int? ?? 0,
    );
  }

  // Copy with method for immutability
  ProductModel copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? category,
    List<String>? images,
    String? thumbnail,
    Map<String, String>? specifications,
    bool? isFavorite,
    bool? isInCart,
    int? cartQuantity,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      images: images ?? this.images,
      thumbnail: thumbnail ?? this.thumbnail,
      specifications: specifications ?? this.specifications,
      isFavorite: isFavorite ?? this.isFavorite,
      isInCart: isInCart ?? this.isInCart,
      cartQuantity: cartQuantity ?? this.cartQuantity,
    );
  }
}
