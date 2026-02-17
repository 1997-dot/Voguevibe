import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
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
        context.read<ProfileCubit>().setUser(authState.user.id);
      }
      context.read<ProfileCubit>().loadProfile();
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
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User Info Section
                        ProfileHeaderSection(
                          userName: state.userProfile.name,
                          userEmail: state.userProfile.email,
                          onEditPressed: () {
                            // Handle edit profile
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

                        // Orders section
                        _buildOrdersSection(state),
                      ],
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersSection(ProfileLoaded state) {
    if (state.isOrdersLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 40),
          child: CircularProgressIndicator(
            color: AppColors.raspberryPlum,
          ),
        ),
      );
    }

    if (!state.hasOrders) {
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
      return OrderData(
        orderNumber: order.orderNumber,
        products: order.items.map((item) {
          return OrderProduct(
            name: item.productName,
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
}
