import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../checkout/presentation/pages/checkout_page.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_summary.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartCubit>().loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
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
            title: 'Shopping Cart',
            actionImage: const SizedBox(width: 24),
          ),

          // Scrollable cart product cards
          Expanded(
            child: BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                if (state is CartLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.raspberryPlum,
                    ),
                  );
                }

                if (state is CartError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: AppColors.white),
                    ),
                  );
                }

                if (state is CartLoaded) {
                  if (state.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            color: AppColors.alabasterGrey,
                            size: 64,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Your cart is empty',
                            style: TextStyle(
                              color: AppColors.alabasterGrey,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: state.cartProducts.length,
                    itemBuilder: (context, index) {
                      final product = state.cartProducts[index];
                      return CartProductCard(
                        imageUrl: product.thumbnail,
                        productName: product.title,
                        priceText: '\$${product.price.toStringAsFixed(0)}',
                        quantity: product.cartQuantity,
                        onIncrease: () {
                          context.read<CartCubit>().incrementQuantity(product.id);
                        },
                        onDecrease: () {
                          context.read<CartCubit>().decrementQuantity(product.id);
                        },
                        onRemove: () {
                          context.read<CartCubit>().removeFromCart(product.id);
                        },
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),

          // Fixed CartSummaryBar at bottom
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state is CartLoaded && !state.isEmpty) {
                final totalText = '\$${state.cartTotal.toStringAsFixed(2)}';
                return CartSummaryBar(
                  subtotalText: totalText,
                  totalPriceText: totalText,
                  onCheckoutTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CheckoutPage()),
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
