import '../../../../data/models/order_model.dart' as legacy;
import '../../domain/entities/order.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.orderNumber,
    required super.items,
    required super.totalPrice,
    required super.orderDate,
    required super.status,
  });

  /// Bridge from legacy OrderModel to profile domain entity.
  /// Extracts orderNumber from legacy ID (e.g. "order_1234567890" → last 6 digits).
  factory OrderModel.fromLegacy(legacy.OrderModel order) {
    final numberStr = order.id.replaceAll(RegExp(r'[^0-9]'), '');
    final orderNumber = int.tryParse(
          numberStr.length > 6
              ? numberStr.substring(numberStr.length - 6)
              : numberStr,
        ) ??
        0;

    return OrderModel(
      id: order.id,
      orderNumber: orderNumber,
      items: order.products
          .map((item) => OrderItemModel.fromLegacy(item))
          .toList(),
      totalPrice: order.totalPrice,
      orderDate: order.orderDate,
      status: order.status,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as int,
      items: (json['items'] as List)
          .map((item) => OrderItemModel.fromJson(item))
          .toList(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      orderDate: DateTime.parse(json['orderDate'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'items': items.map((item) => (item as OrderItemModel).toJson()).toList(),
      'totalPrice': totalPrice,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
    };
  }
}

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.productId,
    required super.productName,
    required super.quantity,
    required super.price,
  });

  /// Bridge from legacy OrderProductItem to profile domain entity.
  factory OrderItemModel.fromLegacy(legacy.OrderProductItem item) {
    return OrderItemModel(
      productId: item.productId,
      productName: item.productTitle,
      quantity: item.quantity,
      price: item.price,
    );
  }

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }
}
