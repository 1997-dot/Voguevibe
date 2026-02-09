import 'package:equatable/equatable.dart';
import '../../../../data/models/order_model.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CheckoutInitial extends CheckoutState {}

/// Loading state (processing order)
class CheckoutLoading extends CheckoutState {}

/// Order success state
class CheckoutSuccess extends CheckoutState {
  final OrderModel order;

  const CheckoutSuccess(this.order);

  @override
  List<Object?> get props => [order];
}

/// Order failed state
class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Orders loaded state (order history)
class OrdersLoaded extends CheckoutState {
  final List<OrderModel> orders;

  const OrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];

  /// Check if order history is empty
  bool get isEmpty => orders.isEmpty;

  /// Get order by ID
  OrderModel? getOrderById(String orderId) {
    try {
      return orders.firstWhere((o) => o.id == orderId);
    } catch (e) {
      return null;
    }
  }
}
