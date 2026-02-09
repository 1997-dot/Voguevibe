class Order {
  final String id;
  final int orderNumber;
  final List<OrderItem> items;
  final double totalPrice;
  final DateTime orderDate;
  final String status;

  const Order({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.totalPrice,
    required this.orderDate,
    required this.status,
  });
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });
}
