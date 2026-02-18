import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../../../favorites/presentation/cubit/favorites_cubit.dart';

class ProductDetailsBottomSheet extends StatelessWidget {
  final String productId;
  final String imageUrl;
  final String productTitle;
  final double price;
  final String description;
  final Map<String, String> specifications;
  final bool isFavorite;
  final bool isInCart;

  const ProductDetailsBottomSheet({
    super.key,
    required this.productId,
    required this.imageUrl,
    required this.productTitle,
    required this.price,
    required this.description,
    required this.specifications,
    required this.isFavorite,
    required this.isInCart,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.85,
      decoration: BoxDecoration(
        color: AppColors.blackberryCream.withValues(alpha: 0.85),
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24.0)),
        border: Border.all(color: AppColors.carbonBlack, width: 1.0),
      ),
      child: ClipRRect(
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24.0)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.alabasterGrey.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product image
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.asset(
                            imageUrl,
                            width: double.infinity,
                            height: 280,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              height: 280,
                              color: AppColors.carbonBlack,
                              child: const Center(
                                child: Icon(Icons.broken_image,
                                    color: AppColors.white, size: 48),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Title + Price row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              productTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '\$${price.toStringAsFixed(0)}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.raspberryPlum,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Description
                      Text(
                        'Description',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: AppColors.alabasterGrey,
                              height: 1.5,
                            ),
                      ),
                      const SizedBox(height: 24),

                      // Specifications
                      if (specifications.isNotEmpty) ...[
                        Text(
                          'Specifications',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                        ),
                        const SizedBox(height: 12),
                        ...specifications.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    entry.key,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.raspberryPlum,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    entry.value,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.alabasterGrey,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Fixed action buttons at bottom
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        final inCart = context.read<CartCubit>().isInCart(productId);
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.carbonBlack.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Add to Cart button
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final cartCubit = context.read<CartCubit>();
                        if (inCart) {
                          cartCubit.removeFromCart(productId);
                        } else {
                          cartCubit.addToCart(productId);
                        }
                      },
                      icon: Icon(
                        inCart ? Icons.check : Icons.add_shopping_cart,
                        size: 20,
                      ),
                      label: Text(
                        inCart ? 'Added To Cart' : 'Add to Cart',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            inCart ? AppColors.white : AppColors.raspberryPlum,
                        foregroundColor:
                            inCart ? AppColors.black : AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Favorite button
              SizedBox(
                height: 50,
                width: 50,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<FavoritesCubit>().toggleFavorite(productId);
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: AppColors.raspberryPlum, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: AppColors.raspberryPlum,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
