import 'cart_item.dart';

/// Cart entity — aggregates cart items with computed totals.
class CartEntity {
  final List<CartItemEntity> items;
  final double total;
  final int itemsCount;

  const CartEntity({
    required this.items,
    required this.total,
    required this.itemsCount,
  });

  bool get isEmpty => items.isEmpty;
}
