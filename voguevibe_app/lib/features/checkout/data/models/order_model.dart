import '../../../../data/models/order_model.dart';
import '../../domain/entities/order.dart';

/// Bridge model that converts legacy OrderModel to domain OrderEntity.
/// No proxy needed — OrderModel is immutable (all final fields).
class CheckoutOrderModel extends OrderEntity {
  CheckoutOrderModel._({
    required super.id,
    required super.products,
    required super.totalPrice,
    required super.orderDate,
    super.status,
    super.shippingAddress,
    super.paymentMethod,
  });

  factory CheckoutOrderModel.fromLegacy(OrderModel legacy) {
    return CheckoutOrderModel._(
      id: legacy.id,
      products: legacy.products
          .map((item) => CheckoutProductItemModel.fromLegacy(item))
          .toList(),
      totalPrice: legacy.totalPrice,
      orderDate: legacy.orderDate,
      status: legacy.status,
      shippingAddress: legacy.shippingAddress,
      paymentMethod: legacy.paymentMethod,
    );
  }
}

/// Bridge model for order product items.
class CheckoutProductItemModel extends OrderProductItemEntity {
  const CheckoutProductItemModel._({
    required super.productId,
    required super.productTitle,
    required super.productThumbnail,
    required super.quantity,
    required super.price,
  });

  factory CheckoutProductItemModel.fromLegacy(OrderProductItem legacy) {
    return CheckoutProductItemModel._(
      productId: legacy.productId,
      productTitle: legacy.productTitle,
      productThumbnail: legacy.productThumbnail,
      quantity: legacy.quantity,
      price: legacy.price,
    );
  }
}
