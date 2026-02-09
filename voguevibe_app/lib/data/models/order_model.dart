import 'product_model.dart';

class OrderModel {
  final String id;
  final List<OrderProductItem> products;
  final double totalPrice;
  final DateTime orderDate;
  final String status;
  final String? shippingAddress;
  final String? paymentMethod;

  OrderModel({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.orderDate,
    this.status = 'Pending',
    this.shippingAddress,
    this.paymentMethod,
  });

  // JSON Serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'products': products.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
    };
  }

  // JSON Deserialization
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      products: (json['products'] as List)
          .map((item) => OrderProductItem.fromJson(item))
          .toList(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      orderDate: DateTime.parse(json['orderDate'] as String),
      status: json['status'] as String? ?? 'Pending',
      shippingAddress: json['shippingAddress'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
    );
  }

  // Create order from cart products
  factory OrderModel.fromCartProducts({
    required List<ProductModel> cartProducts,
    String? shippingAddress,
    String? paymentMethod,
  }) {
    final orderItems = cartProducts.map((product) {
      return OrderProductItem(
        productId: product.id,
        productTitle: product.title,
        productThumbnail: product.thumbnail,
        quantity: product.cartQuantity,
        price: product.price,
      );
    }).toList();

    final total = cartProducts.fold(
      0.0,
      (sum, product) => sum + (product.price * product.cartQuantity),
    );

    return OrderModel(
      id: 'order_${DateTime.now().millisecondsSinceEpoch}',
      products: orderItems,
      totalPrice: total,
      orderDate: DateTime.now(),
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
    );
  }
}

class OrderProductItem {
  final String productId;
  final String productTitle;
  final String productThumbnail;
  final int quantity;
  final double price;

  OrderProductItem({
    required this.productId,
    required this.productTitle,
    required this.productThumbnail,
    required this.quantity,
    required this.price,
  });

  double get subtotal => price * quantity;

  // JSON Serialization
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productTitle': productTitle,
      'productThumbnail': productThumbnail,
      'quantity': quantity,
      'price': price,
    };
  }

  // JSON Deserialization
  factory OrderProductItem.fromJson(Map<String, dynamic> json) {
    return OrderProductItem(
      productId: json['productId'] as String,
      productTitle: json['productTitle'] as String,
      productThumbnail: json['productThumbnail'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }
}
