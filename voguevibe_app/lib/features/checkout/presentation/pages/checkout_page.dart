import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../cubit/checkout_cubit.dart';
import '../cubit/checkout_state.dart';
import '../widgets/order_summary_card.dart';
import '../widgets/payment_method.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cashOnDelivery;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthAuthenticated) {
        context.read<CheckoutCubit>().setUser(authState.user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, checkoutState) {
        if (checkoutState is CheckoutSuccess) {
          return _buildSuccessScreen(checkoutState);
        }
        return _buildCheckoutScreen(checkoutState);
      },
    );
  }

  Widget _buildCheckoutScreen(CheckoutState checkoutState) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Column(
        children: [
          // Fixed AppBar
          CustomFlexibleAppBar(
            height: 90,
            leadingIcon: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.alabasterGrey,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: 'Secure Checkout',
            actionImage: const SizedBox(width: 24),
          ),

          // Scrollable content
          Expanded(
            child: BlocBuilder<CartCubit, CartState>(
              builder: (context, cartState) {
                if (cartState is CartLoaded && !cartState.isEmpty) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order Summary title
                        const Text(
                          'Order Summary',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Order Summary widget
                        OrderSummarySection(
                          products: cartState.cartProducts.map((p) {
                            return OrderProduct(
                              image: p.thumbnail,
                              name: p.title,
                              quantity: p.cartQuantity,
                              price: p.price * p.cartQuantity,
                            );
                          }).toList(),
                          subtotal: cartState.cartTotal,
                          total: cartState.cartTotal,
                          backgroundColor: AppColors.carbonBlack,
                          borderColor: AppColors.blackberryCream,
                        ),
                        const SizedBox(height: 32),

                        // Payment Method title
                        const Text(
                          'Payment Method',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Payment Method selector
                        PaymentMethodSelector(
                          onMethodChanged: (method) {
                            _selectedPaymentMethod = method;
                          },
                        ),
                        const SizedBox(height: 32),

                        // Place Order button
                        if (checkoutState is CheckoutLoading)
                          const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.raspberryPlum,
                            ),
                          )
                        else
                          AppButton(
                            text: 'Place Order',
                            icon: Icons.check_circle_outline,
                            onPressed: () {
                              final methodName = _selectedPaymentMethod ==
                                      PaymentMethod.cashOnDelivery
                                  ? 'Cash on Delivery'
                                  : 'Credit / Debit Card';
                              context.read<CheckoutCubit>().createOrder(
                                    paymentMethod: methodName,
                                  );
                            },
                          ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                }

                return const Center(
                  child: Text(
                    'Your cart is empty',
                    style: TextStyle(
                      color: AppColors.alabasterGrey,
                      fontSize: 18,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessScreen(CheckoutSuccess state) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.raspberryPlum.withValues(alpha: 0.15),
                  border: Border.all(
                    color: AppColors.raspberryPlum,
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.raspberryPlum,
                  size: 56,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                'Order Confirmed!',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              const Text(
                'Your order has been placed successfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.alabasterGrey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),

              // Order ID
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.carbonBlack,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.blackberryCream,
                    width: 1,
                  ),
                ),
                child: Text(
                  'Order ID: ${state.order.id}',
                  style: const TextStyle(
                    color: AppColors.alabasterGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Total
              Text(
                '\$${state.order.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.raspberryPlum,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              // Go Back To Home Page button
              AppButton(
                text: 'Go Back To Home Page',
                icon: Icons.home_rounded,
                onPressed: () {
                  context.read<CheckoutCubit>().reset();
                  context.read<CartCubit>().loadCart();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                    (_) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
