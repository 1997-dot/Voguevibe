import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/result.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/place_order_usecase.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final PlaceOrderUseCase _placeOrderUseCase;
  final GetOrdersUseCase _getOrdersUseCase;

  String? _currentUserId;

  CheckoutCubit({
    required PlaceOrderUseCase placeOrderUseCase,
    required GetOrdersUseCase getOrdersUseCase,
  })  : _placeOrderUseCase = placeOrderUseCase,
        _getOrdersUseCase = getOrdersUseCase,
        super(CheckoutInitial());

  /// Set current user
  void setUser(String? userId) {
    _currentUserId = userId;
  }

  /// Create order from cart
  Future<void> createOrder({
    String? shippingAddress,
    String? paymentMethod,
  }) async {
    if (_currentUserId == null) {
      emit(const CheckoutError('Please login to place an order'));
      return;
    }

    emit(CheckoutLoading());

    final result = await _placeOrderUseCase(
      userId: _currentUserId!,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
    );
    switch (result) {
      case Success(data: final order):
        emit(CheckoutSuccess(order));
      case Failure(message: final msg):
        emit(CheckoutError('Failed to create order: $msg'));
    }
  }

  /// Load user orders (order history)
  Future<void> loadUserOrders() async {
    if (_currentUserId == null) {
      emit(const OrdersLoaded([]));
      return;
    }

    emit(CheckoutLoading());

    final result =
        await _getOrdersUseCase(userId: _currentUserId!);
    switch (result) {
      case Success(data: final orders):
        emit(OrdersLoaded(orders));
      case Failure(message: final msg):
        emit(CheckoutError('Failed to load orders: $msg'));
    }
  }

  /// Reset to initial state
  void reset() {
    emit(CheckoutInitial());
  }
}
