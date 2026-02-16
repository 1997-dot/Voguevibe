import 'cart_item_model.dart';

/// Data transfer object for cart data.
class CartDataModel {
  final List<CartItemModel> items;
  final double total;
  final int itemsCount;

  const CartDataModel({
    required this.items,
    required this.total,
    required this.itemsCount,
  });
}
