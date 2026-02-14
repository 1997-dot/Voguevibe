import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../checkout/presentation/cubit/checkout_cubit.dart';
import '../../../checkout/presentation/cubit/checkout_state.dart';
import '../widgets/order_history_card.dart';
import '../widgets/profile_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthAuthenticated) {
        context.read<CheckoutCubit>().setUser(authState.user.id);
      }
      context.read<CheckoutCubit>().loadUserOrders();
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
            title: 'Profile',
            actionImage: IconButton(
              icon: const Icon(
                Icons.settings,
                color: AppColors.white,
              ),
              onPressed: () {
                // Handle settings
              },
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info Section
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthAuthenticated) {
                        return ProfileHeaderSection(
                          userName: state.user.name,
                          userEmail: state.user.email,
                          onEditPressed: () {
                            // Handle edit profile
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  const SizedBox(height: 32),

                  // Orders History Title
                  const Text(
                    'My Orders History',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Orders History Section
                  BlocBuilder<CheckoutCubit, CheckoutState>(
                    builder: (context, state) {
                      if (state is CheckoutLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: CircularProgressIndicator(
                              color: AppColors.raspberryPlum,
                            ),
                          ),
                        );
                      }

                      if (state is OrdersLoaded) {
                        if (state.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.receipt_long_outlined,
                                    color: AppColors.alabasterGrey,
                                    size: 64,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No orders yet',
                                    style: TextStyle(
                                      color: AppColors.alabasterGrey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final orders = state.orders.map((order) {
                          // Extract order number from ID (e.g. "order_1234567890" → 1234567890)
                          final numberStr =
                              order.id.replaceAll(RegExp(r'[^0-9]'), '');
                          final orderNumber =
                              int.tryParse(numberStr.length > 6
                                      ? numberStr.substring(
                                          numberStr.length - 6)
                                      : numberStr) ??
                                  0;

                          return OrderData(
                            orderNumber: orderNumber,
                            products: order.products.map((item) {
                              return OrderProduct(
                                name: item.productTitle,
                                quantity: item.quantity,
                              );
                            }).toList(),
                            totalPrice: order.totalPrice,
                          );
                        }).toList();

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            return OrderHistoryItem(
                              orderNumber: order.orderNumber,
                              products: order.products,
                              totalPrice: order.totalPrice,
                            );
                          },
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
