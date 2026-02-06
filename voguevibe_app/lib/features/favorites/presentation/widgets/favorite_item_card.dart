import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class FavoriteProductHighlightCard extends StatelessWidget {
  final String productName;
  final String productPrice;
  final String imageUrl;
  final VoidCallback onButtonPressed;
  final VoidCallback onRemoveFromFavorites;

  const FavoriteProductHighlightCard({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.imageUrl,
    required this.onButtonPressed,
    required this.onRemoveFromFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.blackberryCream.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              // LEFT SIDE: Image
              _ProductImage(imageUrl: imageUrl),

              const SizedBox(width: 16),

              // RIGHT SIDE: Content
              Expanded(
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        productPrice,
                        maxLines: 1,
                        style: const TextStyle(
                          color: AppColors.alabasterGrey,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          // Custom Styled Button
                          _CustomActionButton(
                            label: "Add to Cart",
                            onTap: onButtonPressed,
                          ),
                          const Spacer(),
                          // Favorite Icon
                          GestureDetector(
                            onTap: onRemoveFromFavorites,
                            child: const Icon(
                              Icons.favorite,
                              color: AppColors.raspberryPlum,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String imageUrl;

  const _ProductImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _CustomActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _CustomActionButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.raspberryPlum,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Add to Cart",
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
