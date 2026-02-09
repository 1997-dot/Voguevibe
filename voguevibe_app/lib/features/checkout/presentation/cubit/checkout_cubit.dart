import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/repositories/product_repository.dart';
import '../../../../data/managers/user_data_manager.dart';
import '../../../../data/models/order_model.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final ProductRepository _repository = ProductRepository();
  final UserDataManager _userDataManager = UserDataManager();

  String? _currentUserId;

  CheckoutCubit() : super(CheckoutInitial());

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

    try {
      // Get cart products
      final cartProducts = _repository.getCartProducts();

      if (cartProducts.isEmpty) {
        emit(const CheckoutError('Cart is empty'));
        return;
      }

      // Create order
      final order = OrderModel.fromCartProducts(
        cartProducts: cartProducts,
        shippingAddress: shippingAddress,
        paymentMethod: paymentMethod,
      );

      // Save order
      await _userDataManager.addOrder(_currentUserId!, order);

      // Clear cart
      _repository.clearCart();
      await _userDataManager.clearCart(_currentUserId!);

      emit(CheckoutSuccess(order));
    } catch (e) {
      emit(CheckoutError('Failed to create order: ${e.toString()}'));
    }
  }

  /// Load user orders (order history)
  Future<void> loadUserOrders() async {
    if (_currentUserId == null) {
      emit(const OrdersLoaded([]));
      return;
    }

    emit(CheckoutLoading());

    try {
      final orders = await _userDataManager.getUserOrders(_currentUserId!);
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(CheckoutError('Failed to load orders: ${e.toString()}'));
    }
  }

  /// Reset to initial state
  void reset() {
    emit(CheckoutInitial());
  }
}
