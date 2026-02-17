/// Order entity — pure Dart, no framework imports.
class OrderEntity {
  final String id;
  final List<OrderProductItemEntity> products;
  final double totalPrice;
  final DateTime orderDate;
  final String status;
  final String? shippingAddress;
  final String? paymentMethod;

  const OrderEntity({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.orderDate,
    this.status = 'Pending',
    this.shippingAddress,
    this.paymentMethod,
  });
}

/// Order product item entity.
class OrderProductItemEntity {
  final String productId;
  final String productTitle;
  final String productThumbnail;
  final int quantity;
  final double price;

  const OrderProductItemEntity({
    required this.productId,
    required this.productTitle,
    required this.productThumbnail,
    required this.quantity,
    required this.price,
  });

  double get subtotal => price * quantity;
}
